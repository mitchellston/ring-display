FROM karsten13/magicmirror:v2.26.0

USER root

# Update apt configuration to disable signature verification
RUN echo 'Acquire::AllowInsecureRepositories "true";' > /etc/apt/apt.conf.d/99allow-insecure-repositories

RUN echo "deb http://mirror1.ku.ac.th/raspbian  buster main contrib non-free rpi" > /etc/apt/sources.list
# mirror http://mirror.de.leaseweb.net/raspbian/raspbian
RUN echo "deb http://mirror.de.leaseweb.net/raspbian/raspbian buster main contrib non-free rpi" > /etc/apt/sources.list

# Install required packages
RUN apt-get update && apt upgrade -y --allow-unauthenticated
RUN apt-get --allow-unauthenticated install -y sudo && rm -rf /var/lib/apt/lists/*
RUN usermod -aG sudo node

USER node

# Instal gnupg
RUN sudo apt-get update && sudo apt-get install --allow-unauthenticated -y gpgconf gpg gnupg-utils gnupg-l10n
RUN sudo apt-get clean

# Install curl
RUN sudo apt-get update && sudo apt-get install -y --allow-unauthenticated curl \
    && sudo apt-get clean

# Download and extract ffmpeg
RUN sudo curl -Lf https://github.com/homebridge/ffmpeg-for-homebridge/releases/download/v2.1.1/ffmpeg-alpine-arm32v7.tar.gz | sudo tar xzf - -C / --no-same-owner

# Remove the configuration file
RUN sudo rm /etc/apt/apt.conf.d/99allow-insecure-repositories

ENV ELECTRON_DISABLE_GPU=1