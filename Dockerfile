FROM sillelien/base-java
#FROM ubuntu:trusty
MAINTAINER Stepan Mazurov <smazurov@socialengine.com>

RUN apk add --update \
    docker \
    # Install bash for the dind setup script:
    bash \
    # Install py-pip as requirement to install docker-compose:
    py-pip \
    # Install the openssh-client (used by CI agents like buildkite):
    openssh-client \
  # Override the packaged docker (1.6.2) with docker 1.8.2:
  && curl https://get.docker.com/builds/Linux/x86_64/docker-1.8.2 > \
    /usr/bin/docker && chmod 755 /usr/bin/docker \
  # Upgrade pip, install tutum cli and supervisor
  && pip install --upgrade \
    pip tutum supervisor \
  && rm -rf \
    # Clean up any temporary files:
    /tmp/* \
    # Clean up the pip cache:
    /root/.cache \
    # Clean up the apk cache:
    /var/cache/apk/* \
    # Remove any compiled python files (compile on demand):
    `find / -regex '.*\.py[co]'`

ENV DIND_COMMIT=b8bed8832b77a478360ae946a69dab5e922b194e
ADD https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind /usr/local/bin/dind
RUN chmod +x /usr/local/bin/dind

# Define additional metadata for our image.
VOLUME /var/lib/docker
VOLUME /var/log/supervisor


ADD *.sh /usr/local/bin/
ADD version_list /etc/docker/

# Install Jenkins Swarm agent
# variable must be named 'HOME' due to swarm client
ENV HOME /root

RUN mkdir -p /usr/share/jenkins && chmod 755 /usr/share/jenkins
ADD http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/2.0/swarm-client-2.0-jar-with-dependencies.jar \
    /usr/share/jenkins/swarm-client-jar-with-dependencies.jar

ADD https://github.com/docker/compose/releases/download/1.4.2/docker-compose-linux-x86_64 /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Run Docker and Swarm processes with supervisord 
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENTRYPOINT ["/usr/local/bin/setup.sh"]

