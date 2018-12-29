#!/bin/sh

# Copyright (C) CampusIoT,  - All Rights Reserved
# Written by Didier DONSEZ and Vivien QUEMA, 2016-2018

# This script is executed on the Kerlink gateway. It is launched by knetd.

# See https://hobo.house/2016/06/20/fun-and-profit-with-reverse-ssh-tunnels-and-autossh/

NAME=reverse_tunnel
BASE="/mnt/fsuser-1/$NAME"
# BINDIR="/mnt/mmcblk0p1/bin"
BINDIR=$BASE
cd ${BASE}
AUTOSSH=${BINDIR}/autossh
AUTOSSH_NEW_VERSION="${AUTOSSH}_NEW_VERSION"

# AUTOSSH=${BASE}/autossh
LOCAL_SSH_PORT=22
REMOTE_SSH_PORT=2222
DELAY_BEFORE_EXIT_1=120
IDLE_TIME=120


# First time, update or the autossh executable
if [ -f "${AUTOSSH_NEW_VERSION}" ]; then
mv $AUTOSSH_NEW_VERSION $AUTOSSH
fi



NBGATEWAYS=$(wc -l gateway.csv)
if [ "${NBGATEWAYS:0:1}" -ne "1" ]; then
	logger -t campusiot_$NAME "$NAME ($BASE) Malformed gateway.csv file"
	sleep $DELAY_BEFORE_EXIT_1
	exit 1
fi

# Parse gateway.csv
# $1 is hostname (TODO check hostname)
SERVER_REMOTEIP=`awk -F "\"*,\"*" '{print $2}'  gateway.csv`
GATEWAY_SSH_PORT=`awk -F "\"*,\"*" '{print $3}' gateway.csv`
SERVER_REMOTEUSER=`awk -F "\"*,\"*" '{print $4}' gateway.csv`

SERVER_REMOTEUSER_RSAPRIV=${BASE}/${SERVER_REMOTEUSER}.priv
SERVER_REMOTEUSER_DROPBEAR=${BASE}/${SERVER_REMOTEUSER}.dropbear

# First time, copy server hash into known hosts
# TODO (TEMPORARY USE OF -y in the ssh command line)

# convert .pem in .dropbear if .pem is new
if [ -f "$SERVER_REMOTEUSER_RSAPRIV" ]; then
	dropbearconvert openssh dropbear $SERVER_REMOTEUSER_RSAPRIV $SERVER_REMOTEUSER_DROPBEAR
	rm $SERVER_REMOTEUSER_RSAPRIV
fi

logger -t campusiot_$NAME  "$NAME ($BASE) starting ... (remote=$SERVER_REMOTEIP port=$GATEWAY_SSH_PORT)"

#   Disconnect the session if no traffic is transmitted or received for idle_timeout seconds.
#	Autossh is relanched again and again by knet for rejuvinating the ssh connection.
$AUTOSSH -M 0 -i $SERVER_REMOTEUSER_DROPBEAR $SERVER_REMOTEUSER@$SERVER_REMOTEIP -N  -R $GATEWAY_SSH_PORT:localhost:$LOCAL_SSH_PORT -p $REMOTE_SSH_PORT -y -I $IDLE_TIME

logger -t campusiot_$NAME  "$NAME ($BASE) stopped (remote=$SERVER_REMOTEIP port=$GATEWAY_SSH_PORT)"
