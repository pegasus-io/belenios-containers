#!/bin/bash

export OPS_HOME=$(pwd)
# -- Build the minimal platform
docker-compose -f docker-compose.build.yml up -d belenios_backend_minimal
# docker-compose -f docker-compose.build.yml logs -f belenios_backend_minimal

# docker exec belenios_backend_minimal_build bash -c "/belenios/build.sh"
docker-compose -f docker-compose.build.yml logs -f belenios_backend_minimal

# docker exec -it belenios_backend_minimal_build bash -c "./src_code/_build/install/default/bin/belenios-tool --version"
# docker exec -it belenios_backend_minimal_build bash -c "./src_code/_build/install/default/bin/belenios-tool --help"
# ---
# the executable below is a symlink to an executable called "tool_cmdline.exe"
ls -allh ./oci/builder/platform/minimal/belenios_sys_root/_build/install/default/bin/belenios-tool
# here is the actual location of "tool_cmdline.exe"
ls -allh ./oci/builder/platform/minimal/belenios_sys_root/_build/default/src/tool/tool_cmdline.exe
# ./oci/builder/platform/minimal/belenios_sys_root/_build/install/default/bin/belenios-tool --version
# ./oci/builder/platform/minimal/belenios_sys_root/_build/default/src/tool/tool_cmdline.exe --version
# mkdir ~/.anywhere-i-install-belenios && cp ./oci/builder/platform/minimal/belenios_sys_root/_build/default/src/tool/tool_cmdline.exe ~/.anywhere-i-install-belenios
# ~/.anywhere-i-install-belenios/tool_cmdline.exe --version

# --- #
ls -allh oci/builder/platform/minimal/belenios_sys_root/_build/install/default/lib
# all 4 below are directories
ls -allh oci/builder/platform/minimal/belenios_sys_root/_build/install/default/lib/belenios
ls -allh oci/builder/platform/minimal/belenios_sys_root/_build/install/default/lib/belenios-platform
ls -allh oci/builder/platform/minimal/belenios_sys_root/_build/install/default/lib/belenios-platform-native
ls -allh oci/builder/platform/minimal/belenios_sys_root/_build/install/default/lib/belenios-tool
# --- #

# --- #
# Now I'll build a container wich will only have the [belenios-tool] executable, nothing else, in a bare debian
if [ -f ./oci/builder/platform/belenios-tool-runner/tool_cmdline.exe ]; then
  rm ./oci/builder/platform/belenios-tool-runner/tool_cmdline.exe
fi;

cp ./oci/builder/platform/minimal/belenios_sys_root/_build/default/src/tool/tool_cmdline.exe ./oci/builder/platform/belenios-tool-runner

export CCI_USER_UID=$(id -u)
export CCI_USER_GID=$(id -g)
export NON_ROOT_USER_UID=${CCI_USER_UID}
export NON_ROOT_USER_NAME=$(whoami)
export NON_ROOT_USER_GID=${CCI_USER_GID}
export NON_ROOT_USER_GRP=${NON_ROOT_USER_NAME}

docker-compose -f docker-compose.build.yml up -d belenios_tool_runtime

docker exec -it belenios_tool_runtime_build bash -c "belenios-tool --version"
