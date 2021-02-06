#!/bin/bash

export OPS_HOME=$(pwd)

docker-compose -f docker-compose.build.yml up -d --force-recreate belenios_tool_runtime

# ---
# -- run the [demo.sh] script which runs an entire election
ls -allh ./oci/builder/platform/minimal/belenios_sys_root/tests/tool/demo.sh
# the [belenios-tool ()]function is declared into the [demo.sh] : but we neither want to use it, nor need it


# prepare [default.json] file
if [ -f ./default.json ]; then
  rm ./default.json
fi;
cp ./oci/builder/platform/minimal/belenios_sys_root/files/groups/default.json ./default.json
docker exec -it belenios_tool_runtime_build bash -c "mkdir -p /belenios/.workspace/files/groups"
docker cp ./default.json belenios_tool_runtime_build:/belenios/.workspace/files/groups

# prepare [questions.json] file
if [ -f ./questions.json ]; then
  rm ./questions.json
fi;
cp ./oci/builder/platform/minimal/belenios_sys_root/tests/tool/templates/questions.json ./questions.json
docker exec -it belenios_tool_runtime_build bash -c "mkdir -p /belenios/.workspace/tests/tool/templates"
docker cp ./questions.json belenios_tool_runtime_build:/belenios/.workspace/tests/tool/templates

docker exec -it belenios_tool_runtime_build bash -c "mkdir -p /belenios/.workspace/tests/tool/data"

# install [demo-election.sh] shell script
if [ -f ./demo-election.sh ]; then
  rm ./demo-election.sh
fi;
cp ./oci/builder/platform/minimal/belenios_sys_root/tests/tool/demo.sh ./demo-election.sh
sed -i "s#belenios-tool () {#neutralized-belenios-tool () {#g" ./demo-election.sh
sed -i "s#BELENIOS=.*#BELENIOS=\$(pwd)#g" ./demo-election.sh
docker cp ./demo-election.sh belenios_tool_runtime_build:/belenios/.workspace


docker exec -it belenios_tool_runtime_build bash -c "belenios-tool --version"
docker exec -it belenios_tool_runtime_build bash -c "chmod +x /belenios/.workspace/demo-election.sh"
docker exec -it belenios_tool_runtime_build bash -c "cd /belenios/.workspace/ && ./demo-election.sh"


export UUID_DIR=$(docker exec -it belenios_tool_runtime_build bash -c "ls /belenios/.workspace/tests/tool/data/" | tr -d '[:space:]')
docker cp belenios_tool_runtime_build:/belenios/.workspace/tests/tool/data/$UUID_DIR/result.json ./demo-election-result.json
