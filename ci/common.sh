#!/usr/bin/env bash

function log {
    echo $@
}

function checkError {
	if [ $1 -ne 0 ]; then
		log "ERROR"
		exit $1
	fi
	log "OK"
}

function sourceFile {
    if [ -f "$1" ]; then
		source $1
	else 
		log "[Error]: File $1 don't exists."
	fi
}

function getRev {
	BUILD_VER=$(git tag --sort v:refname -l ${1}-* | tail -1)
	if [ -z "${BUILD_VER}" ]; then 
		rev=0
	else
		rev=$(echo ${BUILD_VER} | cut -d"-" -f2)
		if [ -z "${rev}" ]; then
			rev=0
		else
	    	((rev++))
	    fi
	fi
	echo $rev
}

parent_path=$( cd "$(dirname ${BASH_SOURCE[0]})" ; pwd -P )

VERSION=${VERSION:-$(cat $parent_path/version)}
DOCKER_USER=${DOCKER_USER:-"rawmind"}
DOCKER_PASS=${DOCKER_PASS:-"password"}
DOCKER_NAME=${DOCKER_NAME:-"alpine-monit"}
DOCKER_ARCHIVE=${DOCKER_ARCHIVE:-$parent_path"/docker_image"}
GITHUB_USER=${GITHUB_USER:-"rawmind0"}
GITHUB_MAIL=${GITHUB_mail:-"rawmind@gmail.com"}
GITHUB_TOKEN=${GITHUB_TOKEN:-"TOKEN"}
GITHUB_REPO=${GIT_REPO:-"https://x-access-token:"${GITHUB_TOKEN}"@github.com/rawmind0/alpine-monit.git"}

if [ -z "${TAG}" ]; then
	REVISION=$(getRev ${VERSION})
	TAG=${VERSION}"-"${REVISION}
fi

DOCKER_IMAGE=${DOCKER_IMAGE:-${DOCKER_USER}"/"${DOCKER_NAME}":"${TAG}}

cat << EOF > $parent_path/build_version
DOCKER_IMAGE=${DOCKER_IMAGE}
TAG=${TAG}
EOF