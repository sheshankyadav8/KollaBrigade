#!/bin/sh
# Allow for debugging first:
if [ "$1" = "sh" ]; then
  exec sh
fi

# Activate the kolla-build environment:
. /root/.venv/kolla-builds/bin/activate

# Clean up any space previously left from docker builds:
#. /usr/local/bin/clean.sh

cat <<EOF > /tmp/kolla-build.conf 
[DEFAULT]
base=$KOLLA_BASE
install_type=$KOLLA_TYPE
threads=1
namespace='$DOCKER_REGISTRY/$KOLLA_NAMESPACE'
tag=$KOLLA_TAG
[${KOLLA_PROJECT}-base]
type = git
location = $REPO_BASE/${KOLLA_PROJECT}.git
reference = ${PROJECT_REFERENCE}
EOF

echo "print the file"
cat /tmp/kolla-build.conf

cp /tmp/kolla-build.conf /etc/kolla/kolla-build.conf


# Attempt to run kolla-build on container entry:
kolla-build $KOLLA_PROJECT

# TEST ONLY - Push completed containers to the container registry (rework for python/golan):
# REMOVED FOR JENKINS PIPELINE TESTING
#/usr/local/bin/kolla-push.sh

# END