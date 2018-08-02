FROM openjdk:8-jre

USER root

ADD entrypoint.sh /usr/local/bin/

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
    curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - &&\
	echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list &&\
    apt-get update && \
    apt-get -y install --no-install-recommends \
        docker-ce \
        google-chrome-stable \
        jq \
        git \
        zip \
        openssh-client \
        postgresql-client \
        python3-pip \
        python3-setuptools &&\
    # Upgrade pip, install aws cli and libraries
    pip3 install --upgrade pip wheel awscli boto3 &&\
    chmod +x /usr/local/bin/entrypoint.sh &&\
    rm -rf \
    # Clean up apt cache
    /var/lib/apt/lists/* \
    # Clean up any temporary files:
    /tmp/* \
    # Clean up the pip cache:
    /root/.cache \
    # Remove any compiled python files (compile on demand):
    `find / -regex '.*\.py[co]'`

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
