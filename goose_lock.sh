#!/bin/bash
ft_lock
until grep '"ft_lock":' <(xwininfo -tree -root) > /dev/null; do
	sleep 1
done
sleep 1
/mnt/nfs/homes/jmaia/conga/goose /mnt/nfs/homes/jmaia/conga/res/conga-343.mp4 0 0 100 114&
pid=$!
while pgrep -f "ft_lock +-d" > /dev/null; do
	sleep 1
done
kill $pid
