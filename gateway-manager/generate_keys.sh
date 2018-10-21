#!/bin/bash

NB_GATEWAYS=100

generate_keys(){
  USERTOADD=$1
  echo Generate keys for $USERTOADD
  ssh-keygen -q -N "" -b 4096 -C "$USERTOADD@campusiot" -f ./sshkeys/$USERTOADD
}

SSHKEYSDIR="sshkeys"

if [ ! -d "$SSHKEYSDIR" ] ; then
  mkdir -p $SSHKEYSDIR
else
  echo "$SSHKEYSDIR already exists : remove it carefully !"
  exit 1
fi

generate_keys gateway-manager

START=1
while [ $START -le $NB_GATEWAYS ]
do
    PAT=$(printf "%04d" $START)
    USERTOADD="gateway-$PAT"
    generate_keys $USERTOADD
    START=`expr $START + 1`
done
