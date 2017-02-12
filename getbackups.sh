#!/bin/sh

CLIENTS=(
  "db1|backups@127.0.0.1:/mnt/resource/backups"
  "web1|backups@52.165.24.192:/mnt/resource/backups"
  "redmine|backups@37.139.26.24:/srv/backups/last"
)

ITERATIONS=7
WORKDIR="/mnt/backups"

[ ! -d "$WORKDIR" ] && mkdir -p $WORKDIR
for client in ${CLIENTS[@]}; do
  NAME=$(echo "$client" | cut -d "|" -f1)
  SOURCE=$(echo "$client" | cut -d "|" -f2)

  n=$ITERATIONS; until [ $n -lt 1 ]; do
    ((k=n-1))
    [ $n -eq $ITERATIONS ] && rm -rf "$WORKDIR/$NAME/Iteration-$ITERATIONS"
    [ -d "$WORKDIR/$NAME/Iteration-$k" ] && mv "$WORKDIR/$NAME/Iteration-$k" "$WORKDIR/$NAME/Iteration-$n"
    ((n--))
  done
  mkdir -p "$WORKDIR/$NAME/Iteration-1"

  echo -e "\n***\n*** Downloading backups from \"$NAME\"\n***\n"
  rsync -avz --progress --delete --delete-after -e ssh $SOURCE/ $WORKDIR/$NAME/Iteration-1
done
