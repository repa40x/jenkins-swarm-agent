Jenkins Swarm Agent
=====

This is a docker image meant as a jenkins-swarm enabled agent that has capability to run docker images.

It requires `docker.sock` connection and Jenkins Swarm plugin 3.10+ with ability to download the client from the plugin installed in Jenkins.

Contains:

- Jenkins Swarm Client 3.10+ (downloaded automatically from Jenkins)
- Java 8
- Python 3
- AWS Cli
- Git
- PostgreSQL client
- Google Chrome stable

Can be used as Jenkins swarm agent that can launch containers with docker.

### Building
```
docker build -t jenkins-swarm-agent:latest .
```

### Running

This image requires you to give access to host docker via `-v /var/run/docker.sock:/var/run/docker.sock:rw`

To run a Docker container passing 
[any parameters](https://wiki.jenkins-ci.org/display/JENKINS/Swarm+Plugin#SwarmPlugin-AvailableOptions) to the agent:

```
docker run --privileged -e JENKINS_URL=http://jenkins:8080 -v /var/run/docker.sock:/var/run/docker.sock:rw -d jenkins-swarm-agent:latest -username jenkins -password jenkins -executors 1
```

To be able to download Swarm client, environmental variable JENKINS_URL has to be set.

### Attribution

Mashed up versions of [Jenkins Swarm Worker](https://github.com/carlossg/jenkins-swarm-slave-docker),  
[Jenkins Packer Agent](https://github.com/GoogleCloudPlatform/jenkins-packer-agent) and [Jenkins Swarm Agent](https://github.com/SocialEngine/jenkins-swarm-agent) images
