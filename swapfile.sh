#!/bin/bash

SWAPSIZE=2048;
SWAPFILE=/.swapfile

if [ ! -f "$SWAPFILE.lock" ]; then
  touch "$SWAPFILE.lock"
  let "SWAPBLKS=$SWAPSIZE*1024*1024/512"
  if [ ! -f "$SWAPFILE" ]; then
    dd if=/dev/zero of=$SWAPFILE count=$SWAPBLKS
    chown root.root $SWAPFILE
    chmod 600 $SWAPFILE
    /sbin/mkswap $SWAPFILE
  fi
  if [ ! "$(/sbin/swapon -s | grep $SWAPFILE)" ]; then
    /sbin/swapon -v $SWAPFILE
  fi
  rm "$SWAPFILE.lock"
fi
