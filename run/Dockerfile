FROM karsten13/magicmirror:latest

# Update apt configuration to disable signature verification
RUN echo 'Acquire::AllowInsecureRepositories "true";' | sudo tee /etc/apt/apt.conf.d/99allow-insecure-repositories

# Perform apt-get update and install packages
RUN sudo apt-get update && \
    sudo apt-get install --allow-unauthenticated -y gnupg curl && \
    sudo curl -Lf# https://github.com/homebridge/ffmpeg-for-homebridge/releases/download/v2.1.1/ffmpeg-alpine-arm32v7.tar.gz | sudo tar xzf - -C / --no-same-owner && \
    sudo apt-get clean

# Remove the configuration file
RUN sudo rm /etc/apt/apt.conf.d/99allow-insecure-repositories

