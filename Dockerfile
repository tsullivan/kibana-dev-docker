# Use an official Node.js runtime as the base image
FROM node:latest

# Create a new user to avoid using root
RUN useradd -ms /bin/bash developer

# Set the working directory in the container to /home/developer
WORKDIR /home/developer

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl vim \
    fonts-liberation libfontconfig1 libnss3

RUN mkdir /usr/local/nvm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 20.10.0
RUN curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

ADD --chown=developer:developer . /home/developer/kibana-dev

# Change to the new user in the Dockerfile
USER developer

# Make port available to the world outside this container
EXPOSE 5601
