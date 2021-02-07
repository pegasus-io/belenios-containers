#!/bin/bash

export OPS_HOME=$(pwd)

source .env
export BELENIOS_VERSION=${BELENIOS_VERSION:-'master'}
export BELENIOS_GIT_REPO=${BELENIOS_GIT_REPO:-'git@github.com:glondu/belenios.git'}

# export BELENIOS_GIT_CLONE=$(mktemp -d -t "belenios_git_clone-XXXXXXXXXX")
export BELENIOS_GIT_CLONE="${OPS_HOME}/belenios_git_clone_${RANDOM}"

export ALREADY_CLONED=$(ls ${OPS_HOME}/belenios_git_clone_*)
if ! [ "x${ALREADY_CLONED}" == "x" ]; then
  rm -fr belenios_git_clone_*
fi;

git clone ${BELENIOS_GIT_REPO} ${BELENIOS_GIT_CLONE}
cd ${BELENIOS_GIT_CLONE}
git checkout ${BELENIOS_VERSION}
cd ${OPS_HOME}
echo "Belenios source code has been git cloned in [${BELENIOS_GIT_CLONE}]"
# disable sandboxing : otherwise, [opam init] willtry and create a namespace inside containers
sed -i "s#opam init#opam init --disable-sandboxing#g" ${BELENIOS_GIT_CLONE}/opam-bootstrap.sh
# chmod +x *.sh ${PREPARED_DOCKER_CONTEXT}/*.sh


# preparing minimal
export PREPARED_DOCKER_CONTEXT="${OPS_HOME}/oci/builder/platform/minimal"

if [ -f ${PREPARED_DOCKER_CONTEXT}/belenios_sys_root/README.md ]; then
  cp ${PREPARED_DOCKER_CONTEXT}/belenios_sys_root/README.md ${PREPARED_DOCKER_CONTEXT}/README.md
  rm ${PREPARED_DOCKER_CONTEXT}/belenios_sys_root/README.md
fi;
if [ -d ${PREPARED_DOCKER_CONTEXT}/belenios_sys_root/ ]; then
  sudo rm -fr ${PREPARED_DOCKER_CONTEXT}/belenios_sys_root/
fi;
mkdir ${PREPARED_DOCKER_CONTEXT}/belenios_sys_root/
docker-compose -f docker-compose.build.yml down --rmi all
cp -fR ${BELENIOS_GIT_CLONE}/* ${PREPARED_DOCKER_CONTEXT}/belenios_sys_root/
