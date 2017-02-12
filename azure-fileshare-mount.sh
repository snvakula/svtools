#!/bin/sh

USERID="myaccount"
PASSWD="s2/bmV7JX8f3hfiyGl/wXux/QiNHfuehui3hfiwnHSXt3vG+MFtGod0+7GA=="
SRCDIR="azsharedfolderdata"
DSTDIR="/mnt/data"
UIDOWN="sv"
GIDOWN="sv"
FLMODE="0640"
DRMODE="0750"

mountpoint $DSTDIR >/dev/null 2>&1 || {
  mkdir -p $DSTDIR
  mount -t cifs //$USERID.file.core.windows.net/$SRCDIR -o vers=3.0,user=$USERID,password=$PASSWD,dir_mode=$DRMODE,file_mode=$FLMODE,uid=$UIDOWN,gid=$GIDOWN $DSTDIR
}
