alpine-monit
=============

A base image to run anything. It's based in [alpine-base][alpine-base], adding monit as process management

## Build

```
docker build -t rawmind/alpine-monit:<version> .
```

## Process management

This image compiles and intall [monit][monit] under /opt/monit, to make it super simple to start multiple process and manage them correctly.

Starts automatically all services conf files that would be copied in /opt/monit/etc/conf.d or /opt/tools/monit/conf.d (*)

* if you mount a SERVICE_VOLUME at /opt/tools in this container. 


## Versions

- `0.5.20-4` [(Dockerfile)](https://github.com/rawmind0/docker-alpine/blob/0.5.20-4/alpine-monit/Dockerfile) Monit version 5.20
- `0.5.19-2` [(Dockerfile)](https://github.com/rawmind0/docker-alpine/blob/0.5.19-2/alpine-monit/Dockerfile) Monit version 5.19
- `0.5.18-6` [(Dockerfile)](https://github.com/rawmind0/docker-alpine/blob/0.5.18-6/alpine-monit/Dockerfile) Monit version 5.18
- `0.3.3-2` [(Dockerfile)](https://github.com/rawmind0/docker-alpine/blob/0.3.3-2/alpine-base/Dockerfile) Monit version 5.16

## Configuration

This image runs [monit][monit] in foreground.

Besides, you can customize the configuration in several ways:

### Default Configuration

Monit is installed with the default configuration and some parameters can be overrided with env variables:

- MONIT_PORT="2812"             # Port to listen monit httpd service
- MONIT_ALLOW="localhost"       # Rule to allow connections to the httpd port
- MONIT_ARGS="-I"               # Monit exec args
- MONIT_RELOAD="false"          # Set to "true" to automaticly reload monit when the configuration is changed
- SERVICE_VOLUME="/opt/tools"   # Optional volume to get service tools. To know more look at [alpine-tools][alpine-tools]

## Usage

To use this image include `FROM rawmind/alpine-monit` at the top of your `Dockerfile`. Starting from `rawmind/alpine-monit` provides you with the ability to easily start any service using monit. monit will also keep it running for you, restarting it when it crashes.

To start your service using monit:

- create a monit conf file in `/opt/monit/etc/conf.d`
- create a service script that allow start, stop and restart function
- Implement serviceLog function if you want that your service log will be writed to docker logs command.
- example monit and script files:

monit conf
```
check process <service> with pidfile <service-pid-file>
  start program = "<path>/service.sh start"
  stop program = "<path>/service.sh stop"
  if failed port <port> type tcp then restart
```

service script
```
#!/usr/bin/env bash

SERVICE_NAME=zk
SERVICE_HOME=${SERVICE_HOME:-"<service-home>"}
SERVICE_CONF=${SERVICE_CONF:-"0"}

function log {
        echo `date` $ME - $@
}

function serviceLog {
    log "[ Redirecting ${SERVICE_NAME} log... ]"
    ln -sf /proc/1/fd/1 <service log file>
}

function serviceStart {
    log "[ Starting ${SERVICE_NAME}... ]"
    <commands to start service>
}

function serviceStop {
    log "[ Stoping ${SERVICE_NAME}... ]"
    <commands to stop service>
}

function serviceRestart {
    log "[ Restarting ${SERVICE_NAME}... ]"
    serviceStop
    serviceStart
}

case "$1" in
        "start")
            serviceLog
            serviceStart
        ;;
        "stop")
            serviceStop
        ;;
        "restart")
            serviceRestart
        ;;
        *) echo "Usage: $0 restart|start|stop"
        ;;

esac
```


## Examples

Examples of using this image can be found at [alpine-zk][alpine-zk] or at [alpine-kafka][alpine-kafka].

[monit]: https://mmonit.com/monit/
[alpine-base]: https://github.com/rawmind0/alpine-base/
[alpine-zk]: https://github.com/rawmind0/alpine-zk
[alpine-kafka]: https://github.com/rawmind0/alpine-kafka
[alpine-tools]: https://github.com/rawmind0/alpine-tools
