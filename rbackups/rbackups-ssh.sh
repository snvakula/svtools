#!/bin/sh

HOSTSD="/srv/rbackups/hosts.d"
WORKDIR="/mnt/svbackups/Backups"

[ "$1" ] && fnames=$1 || fnames=$(find $HOSTSD -type f)
mkdir -p $WORKDIR
for fname in ${fnames[@]}; do
  echo "[$(date +'%F %T')] Processing $fname:"
  . "$fname"
  if [ "$METHOD" == "ssh" ]; then

    # Remote commands
    echo "[$(date +'%F %T')]   *** Executing remote commands"
    ssh -p "$PORT" "$URL" "$COMMAND" && {

      # Iterations
      echo "[$(date +'%F %T')]   *** Processing iterations"
      n=$ITERATIONS; until [ $n -lt 1 ]; do
        ((k=n-1))
        [ $n -eq $ITERATIONS ] && rm -rf "$WORKDIR/$GROUP/$NAME/Iteration-$ITERATIONS"
        [ -d "$WORKDIR/$GROUP/$NAME/Iteration-$k" ] && mv "$WORKDIR/$GROUP/$NAME/Iteration-$k" "$WORKDIR/$GROUP/$NAME/Iteration-$n"
        ((n--))
      done
      mkdir -p "$WORKDIR/$GROUP/$NAME/Iteration-1"

      # Download
      echo "[$(date +'%F %T')]   *** Downloading artifacts"
      rsync -avz --progress --delete --delete-after -e "ssh -p $PORT" "$URL:$ARTIFACTS/" $WORKDIR/$GROUP/$NAME/Iteration-1

      # Remote cleanup commands
      echo "[$(date +'%F %T')]   *** Executing remote cleanup commands"
      ssh -p "$PORT" "$URL" "$COMMANDAFTER"

    } || { echo "[$(date +'%F %T')]   !!! Cannot connect to the host. Skipping configuration..."; }

  else
    echo "[$(date +'%F %T')]   !!! Method '$METHOD' not allowed here. Skipping configuration..."
  fi

  echo
  unset NAME GROUP URL PORT METHOD ITERATIONS COMMAND ARTIFACTS COMMANDAFTER
done
