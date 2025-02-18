FROM ubuntu:20.04

# Use bash for the shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Upgrade packages to latest version
RUN apt-get update && apt-get upgrade -y

# # Install GCC
RUN apt-get update && apt-get install -y gcc-7 g++-7 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 60

# Install Java Open JDK
RUN apt-get update && apt-get install -y openjdk-11-jdk

# Install Node.js
# From: https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-in-docker
# Create a script file sourced by both interactive and non-interactive bash shells
ENV BASH_ENV "${HOME}/.bash_env"
RUN touch "${BASH_ENV}"
RUN echo '. "${BASH_ENV}"' >> ~/.bashrc
# Install nvm
RUN apt-get update && apt-get install -y curl && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | PROFILE="${BASH_ENV}" bash
# Install node
RUN nvm install 18

# Install NASA DAA Displays
RUN apt-get update && apt-get install -y build-essential rsync git
COPY . /app/daa-displays
WORKDIR /app/daa-displays
RUN make
