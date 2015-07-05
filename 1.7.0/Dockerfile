FROM jpetazzo/dind
MAINTAINER Stepan Mazurov <smazurov@socialengine.com>

RUN export DEBIAN_FRONTEND=noninteractive

# Prereqs
RUN apt-get update

# Installing:
# - default-jre for jenkins swarm
# - supervisor for managing docker and jenkins swarm in a container
# - unzip for aws cli
# 
RUN apt-get install -y supervisor default-jre unzip

RUN apt-get install -y lxc-docker-1.5.0

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker
VOLUME /var/log/supervisor

# Install Jenkins Swarm agent
# variable must be named 'HOME' due to swarm client
ENV HOME /home/jenkins-agent
RUN useradd -c "Jenkins agent" -d ${HOME} -m jenkins-agent
RUN usermod -aG docker jenkins-agent

RUN curl --create-dirs -sSLo \
    /usr/share/jenkins/swarm-client-jar-with-dependencies.jar \
    http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/1.24/swarm-client-1.24-jar-with-dependencies.jar \
    && chmod 755 /usr/share/jenkins

# Install AWS CLI
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
 && unzip awscli-bundle.zip \
 && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

# Run Docker and Swarm processe with supervisord 
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start.sh /usr/local/bin/start.sh

ENTRYPOINT ["/usr/local/bin/start.sh"]

