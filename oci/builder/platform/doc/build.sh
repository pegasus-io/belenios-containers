#!/bin/bash

export BELENIOS_SRC_CODE="/belenios/src_code"
cd ${BELENIOS_SRC_CODE}

./opam-bootstrap.sh

# ---
# [./env.sh] is generated by [./opam-bootstrap.sh] ?
# ---
ls -allh .
tree -a |head -n 30
pwd
echo " oui c ca : [./env.sh]"
chmod a+rwx ./env.sh
cat ./env.sh
ls -allh ./env.sh


export PATH="/root/.belenios/bootstrap/bin:$PATH"
#; export PATH;
export OPAMROOT=/root/.belenios/opam
#; export OPAMROOT;


eval $(opam env) && make doc && make doc/specification.pdf


exit 0
# ---
# Below there is evrrything I still need to test
# ==> Just go and check [https://github.com/glondu/belenios/blob/1.13/.gitlab-ci.yml] to see what can be done.
# ---
# To make sure the build process completed (almost) without errors

# ---
# eval $(opam env) && make check
# 'make check' executes demo automated tests. Those are extremely
# long to run, so I just add them in this image, as a utility, but
# they have to be scale out in a separate batch job.
# ---
# In Belenios source code git repo :
# => in version "1.12" demo/demo.sh exists
# => in version "1.13" demo/demo.sh does not exist anymore
# => in version "1.13" tests must be run using the [make check] Makefile goal
# ---
echo '#!/bin/bash' > /belenios/demo.sh
echo '' > /belenios/demo.sh
echo "cd ${BELENIOS_SRC_CODE}" > /belenios/demo.sh
echo 'eval $(opam env) && make check' > /belenios/demo.sh
chmod +x /belenios/demo.sh && ln -s /belenios/demo.sh /belenios/godemo
export PATH="/belenios:$PATH"
# ok so now to run the demo, I'll just have to execute the [godemo] command


# ---
#
# To compile the command-line tool, you will need: (installed by 'opam' executable)
opam install atdgen zarith cryptokit uuidm cmdliner
# ---
# Now compiling belenios command line tool (Belenios CLI)
# --
# The default goal of make is the first target whose name does not start with ‘.’
#
eval $(opam env) && make
# ---
# The web server has the following additional dependencies: (installed by 'opam' executable)
opam install calendar eliom csv
# ---
# all the dependencies have been
# installed, the Eliom module can be
# compiled with:
eval $(opam env) && make all

# ---
# Documentation
# -
# To generate HTML files from .md ones, you will need Markdown  apt-get install texlive-science
BELENIOS_DOC_MARKDOWN_DEPENDENCIES='markdown texlive-latex-extra texlive-fonts-recommended texlive-fonts-extra lmodern texlive-science'
apt-get install -y ${BELENIOS_DOC_MARKDOWN_DEPENDENCIES}
# Now generating documentation
eval $(opam env) && make doc
