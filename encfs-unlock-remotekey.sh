#!/bin/sh

mountpoint /home/sv/data >/dev/null || echo "$(curl -L https://www.dropbox.com/s/2dhiffdbddbhw2s/svse-svdata.encpw?dl=1)" | sudo encfs -S --public /mnt/sv/data /home/sv/data
