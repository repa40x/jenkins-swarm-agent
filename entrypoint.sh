#!/bin/bash
set -e

print_msg() {
    echo -e "\e[1m${1}\e[0m"
}

#
# Start external docker daemon via mounted socket
#

if ! [ -S /var/run/docker.sock ]; then
    print_msg "Please mount /var/run/docker.sock to connect to docker"
    exit 1;
fi

print_msg "=> Detected unix socket at /var/run/docker.sock"

# If there are no arguments or if args start with '-', run supervisor
# and export args making them available to Swarm client.
if [ -z "$JENKINS_URL" ]; then
    print_msg "=> Please set JENKINS_URL variable"
    exit 1;
fi

print_msg "=> Downloading swarm client"
mkdir -p /usr/share/jenkins
curl -s $JENKINS_URL/swarm/swarm-client.jar -o /usr/share/jenkins/swarm-client.jar

print_msg "=> Starting swarm client"
if [[ $# -lt 1 ]] || [[ "$1" == "-"* ]]; then
    # if -master is not provided
    if [[ "$@" != *"-master "* ]]; then
        ADDR="$JENKINS_URL"
        print_msg "=> Setting jenkins master to ${ADDR}"
        PARAMS="-master ${ADDR}"
    fi
    if [[ "$@" != *"-username "* ]] && [ ! -z "${JENKINS_USERNAME}" ]; then
        print_msg "=> Setting jenkins user"
        PARAMS="${PARAMS} -username ${JENKINS_USERNAME}"
    fi

    if [[ "$@" != *"-password "* ]] && [ ! -z "${JENKINS_PASSWORD}" ]; then
        print_msg "=> Setting jenkins password"
        PARAMS="${PARAMS} -password ${JENKINS_PASSWORD}"
    fi

    SWARMARGS="$@ $PARAMS"
    exec java -jar /usr/share/jenkins/swarm-client.jar -fsroot ${HOME} ${SWARMARGS}
fi

# Assume arg is a process the user wants to run
exec "$@"