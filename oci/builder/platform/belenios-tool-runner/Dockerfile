ARG DEBIAN_BASE_IMAGE_TAG=slim
FROM debian:${DEBIAN_BASE_IMAGE_TAG}


ARG BELENIOS_BUILD_DEPENDENCIES='libgmp-dev'
RUN apt-get update -y  && apt-get install -y ${BELENIOS_BUILD_DEPENDENCIES} tree

RUN mkdir -p /usr/local/bin && mkdir -p /belenios/.install && mkdir -p /belenios/.runner && mkdir -p /belenios/.workspace
# ENV PATH=${PATH}:/belenios/.install
COPY tool_cmdline.exe /belenios/.install
RUN chmod a+x /belenios/.install/tool_cmdline.exe && ln -s /belenios/.install/tool_cmdline.exe /usr/local/bin/belenios-tool
RUN belenios-tool --version
# --- NON ROOT USER
ARG NON_ROOT_USER_UID=1000
ENV NON_ROOT_USER_UID=$NON_ROOT_USER_UID
ARG NON_ROOT_USER_GID=1000
ENV NON_ROOT_USER_GID=$NON_ROOT_USER_GID

ARG NON_ROOT_USER_NAME=belenios
ENV NON_ROOT_USER_NAME=$NON_ROOT_USER_NAME
ARG NON_ROOT_USER_GRP=belenios
ENV NON_ROOT_USER_GRP=$NON_ROOT_USER_GRP

LABEL oci.image.nonroot.user.name=$NON_ROOT_USER_NAME
LABEL oci.image.nonroot.user.group=$NON_ROOT_USER_GRP
LABEL oci.image.nonroot.user.uid=$NON_ROOT_USER_UID
LABEL oci.image.nonroot.user.gid=$NON_ROOT_USER_GID

RUN groupadd -g $NON_ROOT_USER_GID $NON_ROOT_USER_GRP
RUN useradd -g $NON_ROOT_USER_GRP -u $NON_ROOT_USER_UID -m $NON_ROOT_USER_NAME

RUN chown $NON_ROOT_USER_NAME:$NON_ROOT_USER_GRP -R /belenios
USER $NON_ROOT_USER_NAME
RUN echo "whoami = [$(whoami)]"


CMD [ "belenios-tool", "--version" ]
