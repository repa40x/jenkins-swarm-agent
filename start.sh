#!/bin/bash

print_msg() {
        echo -e "\e[1m${1}\e[0m"
}

# If there are no arguments or if args start with '-', run supervisor
# and export args making them available to Swarm client.
print_msg "=> Starting Boot"
if [[ $# -lt 1 ]] || [[ "$1" == "-"* ]]; then
    # if -master is not provided and using --link jenkins:jenkins
    if [[ "$@" != *"-master "* ]] && [ ! -z "$JENKINS_PORT_8080_TCP_ADDR" ]; then
        ADDR="http://$JENKINS_PORT_8080_TCP_ADDR:$JENKINS_PORT_8080_TCP_PORT"
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
