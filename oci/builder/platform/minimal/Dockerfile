ARG DEBIAN_BASE_IMAGE_TAG=slim
FROM debian:${DEBIAN_BASE_IMAGE_TAG}


ARG BELENIOS_BUILD_DEPENDENCIES='git bubblewrap build-essential libgmp-dev libpcre3-dev pkg-config m4 libssl-dev libsqlite3-dev wget ca-certificates zip unzip libncurses-dev uuid-runtime zlib1g-dev libgd-securityimage-perl cracklib-runtime'
RUN apt-get update -y  && apt-get install -y ${BELENIOS_BUILD_DEPENDENCIES} tree

RUN mkdir -p /belenios/src_code

COPY build.sh /belenios
RUN chmod +x /belenios/build.sh

WORKDIR /belenios

CMD [ "/belenios/build.sh" ]
