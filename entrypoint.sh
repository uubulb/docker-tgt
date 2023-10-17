#!/bin/sh

/usr/bin/tgtd

CREATE_IMAGE() {
      tgtimg --op new --device-type disk --type disk --size $DISK_SIZE --file /pool/$DISK_NAME
}

CREATE_TARGET() {
      tgtadm --lld iscsi --op new --mode target --tid 1 -T $IQN
      tgtadm --lld iscsi --op new --mode logicalunit --tid=1 --lun=1 --backing-store /pool/$DISK_NAME
}

EXPOSE() {
      tgtadm --lld iscsi --op bind --mode target --tid 1 -I $ADDRESS
}

if [ -f "/pool/$DISK_NAME" ];then
  echo "Already created"
  else
  CREATE_IMAGE
fi

CREATE_TARGET

EXPOSE

sleep infinity
