#!/usr/bin/env bash

parent_path=$( cd "$(dirname ${BASH_SOURCE[0]})" ; pwd -P )
source $parent_path/common.sh

if [ -n "$1" ]; then
	sourceFile "$1"
fi

log "Finding ${DOCKER_IMAGE} ..."
list_image=$(docker images -q ${DOCKER_IMAGE})
checkError $?

if [ "$list_image" == "" ]; then
	log "Loading ${DOCKER_IMAGE}..."
	docker load -i ${DOCKER_ARCHIVE}
	checkError $?
fi

log "Configuring git global user data ..."
git config --global user.email "${GITHUB_MAIL}"
git config --global user.name "${GITHUB_USER}"

#log "Checking git Dockerfile changes ${TAG} ..."
#if [ "$(git status --porcelain | grep -q Dockerfile ; echo $?)" -eq "0" ]; then 
#	log "Commiting git Dockerfile changes ${TAG} ..."
#	git commit -am "Dockerfile for ${DOCKER_IMAGE}"
#	checkError $?
#fi

log "Tagging git repo ${TAG} ..."
git tag ${TAG}
checkError $?

log "Pushing git tags ${TAG} ..."
echo git push ${GITHUB_REPO} master --tags
git push ${GITHUB_REPO} master --tags
checkError $?

log "Login to docker registry as ${DOCKER_USER} ..."
docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
checkError $?

log "Pushing docker ${DOCKER_IMAGE} ..."
docker push ${DOCKER_IMAGE}
checkError $?

cat << EOF > $parent_path/released_version
DOCKER_FROM=${DOCKER_IMAGE}
EOF
log "OK"
exit 0
