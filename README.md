# The Containerized Belenios

This recipe supports the following belenios versions :
* `1.13`

* In (a shell session and in) an empty directory, run :

```bash
export FEATURE_ALIAS="belenios-1.13-build"
export DESIRED_VERSION="feature/${FEATURE_ALIAS}"

export BELENIOS_OCI_LIBRARY=git@github.com:pegasus-io/belenios-containers.git

git clone ${BELENIOS_OCI_LIBRARY} .

git checkout ${DESIRED_VERSION}

./prepare.env.sh

./build-belenios-tool-runner.sh

# --- #
# -- Now you can use the belenios tool runner (its only dependency is the 'libgmp-dev' debian package) :
docker exec -it belenios_tool_runtime_build bash -c "belenios-tool --version"


# ---
# Now, just like in https://github.com/glondu/belenios/blob/1.13/tests/tool/demo.sh
# --
# Setup election
export ELECTION_UUID=$(docker exec -it belenios_tool_runtime_build bash -c "belenios-tool generate-token")
echo
echo "=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+="
echo
echo " Example using Belenios Tool : generate the UUID of a new election"
echo
echo " Generated Election UUID is [$ELECTION_UUID]"
echo
echo "=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+="
echo
./test-belenios-tool-runner.sh
cat ./demo-election-result.json | jq .
echo
echo "=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+="
echo
echo " Election Simulation finished !"
echo
echo "=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+="
echo
# --
#
# -- Builds the legacy server designed by the Belenios Team
docker-compose -f docker-compose.build.yml up -d belenios_backend_release_server
docker-compose -f docker-compose.build.yml logs -f belenios_backend_release_server

# -- Run the unit tests : a demo voting session will be performed
docker-compose -f docker-compose.build.yml up -d belenios_unit_tests
docker-compose -f docker-compose.build.yml logs -f belenios_unit_tests

```
