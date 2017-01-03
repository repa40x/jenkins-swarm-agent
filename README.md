Jenkins Swarm Agent
=====

This is a docker image meant as a jenkins-swarm enabled agent that has capability to run docker images.

It requires `docker.sock` connection, and attempts to install latest compatible docker executable locally.

Contains:

- Jenkins Swarm Client 2.2
- Docker 1.12.3
- Docker Compose 1.9.0
- Java 8
- Python
- AWS Cli
- Git

Can be used as Jenkins swarm agent that can launch containers with docker.

### Running

This image requires you to give access to host docker via `-v /var/run/docker.sock:/var/run/docker.sock:rw`

To run a Docker container passing 
[any parameters](https://wiki.jenkins-ci.org/display/JENKINS/Swarm+Plugin#SwarmPlugin-AvailableOptions) to the slave:

```
docker run --privileged --link=jenkins:jenkins -v /var/run/docker.sock:/var/run/docker.sock:rw -d socialengine/dind-jenkins-agent -master http://jenkins:8080 -username jenkins -password jenkins -executors 1
```

When linking to Jenkins master container, there is no need to use `-master`

```
docker run -d --link jenkins:jenkins socialengine/jenkins-swarm-agent -username jenkins -password jenkins -executors 1
```

### Attribution

Mashed up versions of [Jenkins Swarm Worker](https://github.com/carlossg/jenkins-swarm-slave-docker) and 
[Jenkins Packer Agent](https://github.com/GoogleCloudPlatform/jenkins-packer-agent) images
