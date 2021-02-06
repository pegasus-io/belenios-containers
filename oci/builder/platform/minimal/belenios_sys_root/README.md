# What's this folder

In the `${DOCKER_BUILD_CONTEXT}/belenios_sys_root` folder, the `belenios` source code will be git cloned, to be available
into the container at runtime, for the build process


# What's built with the `minimal` ?

The `minimal` `Makefile` target, builds the following:

* `belenios-platform`
* `belenios-platform-native`
* `belenios`
* `belenios-tool`


The question is : Can all those components be built independently ?
