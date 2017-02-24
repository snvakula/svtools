#!/bin/bash
# Deps: php, pwgen, emc

URL="https://emcdpo.local"
SALT="fah6aZfewfwewej"
ADDRESS="ERGPQNKpmJNaXeaq6ZDYwgghQDMBQGVema"
VENDOR="Your Company"

ITEM="Name of your product"
PHOTO="http://www.blockchainengine.org/wp-content/uploads/2016/04/Smart4.png"
OTHERS="Description=The description of your product"
PREFIX="DEMO-"
FIRST=1001
LAST=1030
DAYS=730

while [ $FIRST -le $LAST ]; do
  echo "Creating serial $PREFIX$FIRST:"
  SECRET=$(pwgen 8 1)
  OTP=$(php -r "echo(hash('sha256', md5('$SECRET'.'$SALT')));")
  echo " * SECRET: $SECRET"
  echo " * OTP: $OTP"
  echo " * Public URL: $URL/key/$PREFIX$FIRST"
  echo " * Private URL: $URL/key/$PREFIX$FIRST?otp=$SECRET"

  COUNT=0
  while emc name_show "dpo:$VENDOR:$PREFIX$FIRST:$COUNT" >/dev/null 2>&1
  do
    let COUNT=COUNT+1
  done
  echo " * NVS Record: dpo:$VENDOR:$PREFIX$FIRST:$COUNT"

  VALUE="Item=$ITEM\nPhoto=$PHOTO\n$OTHERS\nOTP=$OTP"
  VALUE=$(echo -e "$VALUE")
  echo -n " * Transaction ID: "
  emc name_new "dpo:$VENDOR:$PREFIX$FIRST:$COUNT" "$VALUE" $DAYS $ADDRESS

  echo
  let FIRST=FIRST+1
done

