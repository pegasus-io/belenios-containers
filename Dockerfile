FROM debian:9.12-slim


# ARG BELENIOS_SRC_CODE=git@gitlab.com:second-bureau/bellerophon/blockchain-jaune/belenios/belenios.git
ARG BELENIOS_SRC_CODE=https://github.com/glondu/belenios

ARG DEPENDENCIES='git bubblewrap build-essential libgmp-dev libpcre3-dev pkg-config m4 libssl-dev libsqlite3-dev wget ca-certificates zip unzip libncurses-dev uuid-runtime zlib1g-dev libgd-securityimage-perl cracklib-runtime'

RUN apt-get update -y  && apt-get install -y ${DEPENDENCIES}

RUN mkdir -p /belenios/install_home

COPY start.sh /belenios
COPY opam-bootstrap.sh /belenios

RUN chmod +x /belenios/*.sh

# RUN git clone $[BELENIOS_SRC_CODE} /belenios/install_home
RUN git clone https://github.com/glondu/belenios /belenios/install_home
WORKDIR /belenios/install_home

# -- JBL CHIRURGIE : je remplace le script par ma version surchargée, utilisant --no-sandbox
RUN rm ./opam-bootstrap.sh 
RUN cp /belenios/opam-bootstrap.sh .
RUN chmod +x ./opam-bootstrap.sh

RUN ./opam-bootstrap.sh

# --- JBL CHIRIRUGIE : je réalise les tests listés dans https://github.com/glondu/belenios/issues/5
# RUN jbuilder --version

ARG BELENIOS_SRC=/belenios/install_home
ENV BELENIOS_SRC=/belenios/install_home

RUN apt-get install -y tree
RUN ls -allh .
RUN tree -a |head -n 30
RUN pwd
RUN echo " oui c ca : [$BELENIOS_SRC/env.sh]"
RUN chmod a+rwx ./env.sh
RUN cat ./env.sh
RUN ls -allh ./env.sh


ARG PATH="/root/.belenios/bootstrap/bin:$PATH"
#; export PATH;
ARG OPAMROOT=/root/.belenios/opam
#; export OPAMROOT;

ENV PATH="/root/.belenios/bootstrap/bin:$PATH"
#; export PATH;
ENV OPAMROOT=/root/.belenios/opam
#; export OPAMROOT;

RUN eval $(opam env) && make all

# RUN BELENIOS_DEBUG=1 make all
# ---
# To make sure the build process completed (almost) without errors

# RUN eval $(opam env) && make check
# 'make check' executes demo automated tests. Those are extremely
# long to run, so I just add them in this image, as a utility, but 
# they have to be scale out in a separate batch job.
RUN echo '#!/bin/bash' > /belenios/demo.sh
RUN echo '' > /belenios/demo.sh
RUN echo 'cd /belenios/install_home' > /belenios/demo.sh
RUN echo 'eval $(opam env) && make check' > /belenios/demo.sh
RUN chmod +x /belenios/demo.sh && ln -s /belenios/demo.sh /belenios/godemo

ARG PATH="/belenios:$PATH"
# - Never the less, I let a part of the demo to be run during the build, as a test the build was successful
RUN mkdir -p demo/data
RUN eval $(opam env) && demo/demo.sh


# ---
# 
# To compile the command-line tool, you will need: (installed by 'opam' executable)
RUN opam install atdgen zarith cryptokit uuidm cmdliner
# ---
# Now commpiling belenios command line tool (Belenios CLI)
RUN eval $(opam env) && make
# ---
# The web server has the following additional dependencies: (installed by 'opam' executable)
RUN opam install calendar eliom csv
# ---
# all the dependencies have been
# installed, the Eliom module can be
# compiled with:
RUN eval $(opam env) && make all

# ---
# Documentation
# -
# To generate HTML files from .md ones, you will need Markdown  apt-get install texlive-science
ARG DOC_MARKDOWN_DEPENDENCIES='markdown texlive-latex-extra texlive-fonts-recommended texlive-fonts-extra lmodern texlive-science'
RUN apt-get install -y ${DOC_MARKDOWN_DEPENDENCIES}
# Now generating documentation
RUN eval $(opam env) && make doc




WORKDIR /belenios

CMD [ "/belenios/start.sh" ]
