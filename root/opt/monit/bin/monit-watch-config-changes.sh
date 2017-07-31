#!/usr/bin/env bash

while true
do
	inotifywait -qr ${MONIT_HOME}/etc/conf.d
	kill -HUP `cat ${MONIT_HOME}/log/monit.pid`
done
