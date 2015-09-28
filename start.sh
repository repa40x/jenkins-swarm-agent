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
  export SWARMARGS="$@ $PARAMS"
  exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
fi

# Assume arg is a process the user wants to run
exec "$@"
