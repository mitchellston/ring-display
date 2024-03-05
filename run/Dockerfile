FROM karsten13/magicmirror:v2.26.0

USER root

# Update apt configuration to disable signature verification
RUN echo 'Acquire::AllowInsecureRepositories "true";' > /etc/apt/apt.conf.d/99allow-insecure-repositories

# Install required packages
RUN apt-get update && apt upgrade -y
RUN apt-get --allow-unauthenticated install -y sudo && rm -rf /var/lib/apt/lists/*
RUN usermod -aG sudo node

USER node
RUN sudo apt-get install -y --no-install-recommends apt-utils --allow-unauthenticated
RUN sudo apt-get install --allow-unauthenticated -y gnupg curl
RUN sudo apt-get clean

# Download and extract ffmpeg
RUN sudo curl -Lf https://github.com/homebridge/ffmpeg-for-homebridge/releases/download/v2.1.1/ffmpeg-alpine-arm32v7.tar.gz | sudo tar xzf - -C / --no-same-owner

# Remove the configuration file
RUN sudo rm /etc/apt/apt.conf.d/99allow-insecure-repositories