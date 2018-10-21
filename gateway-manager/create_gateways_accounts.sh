#!/bin/bash

NB_GATEWAYS=100

add_user(){
  USERTOADD=$1
  USERGROUP=$2
  USERSHELL=$3
  echo Add user $USERTOADD
  useradd -s $USERSHELL -G $USERGROUP -d /home/$USERTOADD $USERTOADD
  mkdir /home/$USERTOADD
  mkdir /home/$USERTOADD/.ssh
  #ssh-keygen -q -N "" -b 4096 -C "$USERTOADD@campusiot" -f /root/sshkeys/$USERTOADD
  mv /root/sshkeys/$USERTOADD.pub /home/$USERTOADD/.ssh/authorized_keys
  chown -R $USERTOADD:$USERGROUP /home/$USERTOADD
}

mkdir /root/sshkeys

addgroup gateway

add_user gateway-manager gateway /bin/bash

START=1
while [ $START -le $NB_GATEWAYS ]
do
    PAT=$(printf "%04d" $START)
    USERTOADD="gateway-$PAT"
    add_user $USERTOADD gateway /bin/press_to_exit.sh
    #add_user $USERTOADD gateway /sbin/nologin
    START=`expr $START + 1`
done
