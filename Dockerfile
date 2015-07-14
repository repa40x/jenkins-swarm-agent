FROM jpetazzo/dind
MAINTAINER Stepan Mazurov <smazurov@socialengine.com>

RUN export DEBIAN_FRONTEND=noninteractive

# Prereqs
RUN apt-get update

# Installing:
# - default-jre for jenkins swarm
# - supervisor for managing docker and jenkins swarm in a container
# - python-pip for tutum cli
# 
RUN apt-get install -y supervisor default-jre python-pip

RUN apt-get install -y lxc-docker-1.5.0

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker
VOLUME /var/log/supervisor

# Install Jenkins Swarm agent
# variable must be named 'HOME' due to swarm client
ENV HOME /root


RUN mkdir -p /usr/share/jenkins && chmod 755 /usr/share/jenkins
ADD http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/1.24/swarm-client-1.24-jar-with-dependencies.jar /usr/share/jenkins/swarm-client-jar-with-dependencies.jar

# Install Tutum CLI
RUN pip install tutum

ADD https://github.com/docker/compose/releases/download/1.2.0/docker-compose-linux-x86_64 /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Run Docker and Swarm processe with supervisord 
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start.sh /usr/local/bin/start.sh

ENTRYPOINT ["/usr/local/bin/start.sh"]

