#!/bin/bash
set -e

print_msg() {
    echo -e "\e[1m${1}\e[0m"
}

#
# Start docker-in-docker or use an external docker daemon via mounted socket
#
DOCKER_USED=""
EXTERNAL_DOCKER=no
MOUNTED_DOCKER_FOLDER=no
if [ -S /var/run/docker.sock ]; then
    print_msg "=> Detected unix socket at /var/run/docker.sock"
    print_msg "=> Testing if docker version matches"
    if ! docker version > /dev/null 2>&1 ; then
        export DOCKER_VERSION=$(cat /etc/docker/version_list | grep -e "^$(docker version 2>&1 > /dev/null | grep -iF "Error response from daemon" | grep -oe 'server API version: *\d*\.\d*' | grep -oe '\d*\.\d*') .*$" | cut -d " " -f2)
        if [ "${DOCKER_VERSION}" != "" ]; then
            print_msg "=> Downloading Docker ${DOCKER_VERSION}"
            curl -o /tmp/docker.tgz https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz
            tar -xzvf /tmp/docker.tgz -C /tmp
            mv /tmp/docker/* /usr/bin/
            rm -r /tmp/docker*
            chmod +x /usr/bin/docker*
        fi
    fi
    docker version > /dev/null 2>&1 || { print_msg "   Failed to connect to docker daemon at /var/run/docker.sock" && exit 1; }
    EXTERNAL_DOCKER=yes
    DOCKER_USED="Using external docker version ${DOCKER_VERSION} mounted at /var/run/docker.sock"
    export DOCKER_USED=${DOCKER_USED}
    export EXTERNAL_DOCKER=${EXTERNAL_DOCKER}
    export MOUNTED_DOCKER_FOLDER=${MOUNTED_DOCKER_FOLDER}
    exec /usr/local/bin/start.sh "$@"
fi

print_msg "Please mount /var/run/docker.sock to connect to docker"
exit 1;
