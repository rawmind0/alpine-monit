#!/usr/bin/env bash

parent_path=$( cd "$(dirname ${BASH_SOURCE[0]})" ; pwd -P )
source $parent_path/common.sh

if [ -n "$1" ]; then
	sourceFile "$1"
fi

log "Getting git tag ${TAG} ..."
CHECK_TAG=$(git tag -l ${TAG})
checkError $?

if [ -n "${CHECK_TAG}" ]; then 
	log "[Error]: git tag ${TAG} already exists"
	exit 1
fi

log "Building ${DOCKER_IMAGE} ..."
docker build -t ${DOCKER_IMAGE} .
checkError $?

log "Saving ${DOCKER_IMAGE} ..."
docker save -o ${DOCKER_ARCHIVE} ${DOCKER_IMAGE}
checkError $?

exit 0