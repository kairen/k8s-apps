#!/bin/sh

set -eu

function stop() {
    echo "Stopping NFS"

    /usr/sbin/rpc.nfsd 0
    /usr/sbin/exportfs -au
    /usr/sbin/exportfs -f

    kill $( pidof rpc.mountd )
    umount /proc/fs/nfsd
    echo > /etc/exports
    exit 0
}

trap stop TERM

echo ${EXPORTS_ENV} > /etc/exports
mount -t nfsd nfds /proc/fs/nfsd

 echo 'starting rpcbind...'
/sbin/rpcbind -w

echo 'starting rpc.nfsd...'
/usr/sbin/exportfs -r
/usr/sbin/rpc.nfsd -G 10 -N 2 -V 3 -N 4 -N 4.1 2
echo "NFS started"

echo 'starting rpc.mountd...'
# -N 4.x: disable NFSv4
# -V 3: enable NFSv3
/usr/sbin/rpc.mountd -N 2 -V 3 -N 4 -N 4.1 --foreground
