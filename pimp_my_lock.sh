#!/bin/bash
if [ $# -lt 1 ]; then
	echo "Usage: $0 <path_to_media> <x> <y> <width> <height>"
	exit 1
fi
ft_lock
until grep '"ft_lock":' <(xwininfo -tree -root) > /dev/null; do
	sleep 1
done
sleep 1
/mnt/nfs/homes/jmaia/conga/goose $1 $2 $3 $4 $5&
pid=$!
while pgrep -f "ft_lock +-d" > /dev/null; do
	sleep 1
done
kill $pid
