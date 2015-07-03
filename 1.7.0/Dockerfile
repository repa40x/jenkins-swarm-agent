FROM jpetazzo/dind
MAINTAINER Stepan Mazurov <smazurov@socialengine.com>

RUN export DEBIAN_FRONTEND=noninteractive

# Prereqs
RUN apt-get update

# Installing:
# - default-jre for jenkins swarm
# - supervisor for managing docker and jenkins swarm in a container
# 
RUN apt-get install -y supervisor default-jre

RUN apt-get install -y lxc-docker-1.7.0

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker
VOLUME /var/log/supervisor

# Install Jenkins Swarm agent
ENV AGENT_HOME /home/jenkins-agent
RUN useradd -c "Jenkins agent" -d ${AGENT_HOME} -m jenkins-agent
RUN usermod -aG docker jenkins-agent

RUN curl --create-dirs -sSLo \
    /usr/share/jenkins/swarm-client-jar-with-dependencies.jar \
    http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/1.24/swarm-client-1.24-jar-with-dependencies.jar \
    && chmod 755 /usr/share/jenkins

# Run Docker and Swarm processe with supervisord 
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start.sh /usr/local/bin/start.sh

ENTRYPOINT ["/usr/local/bin/start.sh"]

