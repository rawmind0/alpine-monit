#!/usr/bin/env bash

while true
do
	inotifywait --exclude '/\..+' -e modify -e move -e create -e delete -qr ${MONIT_HOME}/etc/conf.d
	if monit -t
	then
		kill -HUP `cat ${MONIT_HOME}/log/monit.pid`
	fi
	sleep 1
done
