#! /bin/bash
set -x

MOUNT_AT=$PWD/data/img/$1
if grep -q $MOUNT_AT /etc/mtab; then
   fusermount -u $MOUNT_AT
   if grep -q $MOUNT_AT /etc/mtab; then
       echo "Unmount failed"
       exit 0
   fi
fi
gcsfuse -o allow_other $1  $MOUNT_AT

exit 0

