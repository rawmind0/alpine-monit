#!/usr/bin/env bash

if [ -d "${SERVICE_VOLUME}" ]; then
	while [ ! -f ${SERVICE_VOLUME}/.synced ]; do
		echo `date` $ME - "[ Waiting ${SERVICE_VOLUME} to be synced ... ]"
		sleep 5
	done

	cat << EOF > ${MONIT_HOME}/etc/monitrc
include ${SERVICE_VOLUME}/monit/conf.d/*
include ${MONIT_HOME}/etc/conf.d/*
EOF

else
	cat << EOF > ${MONIT_HOME}/etc/monitrc
include ${MONIT_HOME}/etc/conf.d/*
EOF

fi

chmod 700 ${MONIT_HOME}/etc/monitrc

MONIT_DAEMON=${MONIT_DAEMON:-"60"}
MONIT_PORT=${MONIT_PORT:-"2812"}
MONIT_ALLOW=${MONIT_ALLOW:-"localhost"}
MONIT_ARGS=${MONIT_ARGS:-"-I"}

cat << EOF > ${MONIT_HOME}/etc/conf.d/basic
set daemon ${MONIT_DAEMON}
set logfile ${MONIT_HOME}/log/monit.log
set pidfile ${MONIT_HOME}/log/monit.pid
set statefile ${MONIT_HOME}/log/monit.state

set httpd port ${MONIT_PORT} 
    allow ${MONIT_ALLOW}
EOF

for i in ${MONIT_HOME}/log/monit.pid ${MONIT_HOME}/log/monit.state
do
	if [ -e "$i" ]; then
		echo "Removing $i"
		rm "$i"
	fi
done

trap 'echo "Stopping monit with pid [$PID]"; kill -SIGTERM $PID; wait $PID' SIGTERM SIGINT
${MONIT_HOME}/bin/monit ${MONIT_ARGS} &
PID=$!
wait $PID
