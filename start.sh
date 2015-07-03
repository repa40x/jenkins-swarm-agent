#!/bin/bash

# If there are no arguments or if args start with '-', run supervisor
# and export args making them available to Swarm client.
echo "Starting boot"
if [[ $# -lt 1 ]] || [[ "$1" == "-"* ]]; then
  # if -master is not provided and using --link jenkins:jenkins
  if [[ "$@" != *"-master "* ]] && [ ! -z "$JENKINS_PORT_8080_TCP_ADDR" ]; then
    PARAMS="-master http://$JENKINS_PORT_8080_TCP_ADDR:$JENKINS_PORT_8080_TCP_PORT"
  fi
  export SWARMARGS="$@ $PARAMS"
  exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
fi

# Assume arg is a process the user wants to run
exec "$@"
