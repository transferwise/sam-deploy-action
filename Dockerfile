FROM ubuntu

LABEL version="1.0.0"

LABEL com.github.actions.name="SAM Deploy Action"
LABEL com.github.actions.description="Deploy AWS SAM Stack"
LABEL com.github.actions.icon="upload-cloud"
LABEL com.github.actions.color="blue"

LABEL repository="https://github.com/r0zar/sam-deploy-action"
LABEL homepage="https://github.com/r0zar/sam-deploy-action"
LABEL maintainer="Ross Ragsdale <ross.ragsdale@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y awscli wget unzip
RUN mkdir ~/Downloads && cd ~/Downloads && wget "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" && unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
RUN ~/Downloads/sam-installation/install
RUN rm ~/Downloads/aws-sam-cli-linux-x86_64.zip && rm -r ~/Downloads/sam-installation

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
