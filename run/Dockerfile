FROM karsten13/magicmirror:v2.25.0

USER root

# Update apt configuration to disable signature verification
RUN echo 'Acquire::AllowInsecureRepositories "true";' > /etc/apt/apt.conf.d/99allow-insecure-repositories

# Perform apt-get update and install packages
RUN apt-get update && \
    apt-get install --allow-unauthenticated -y gnupg curl && \
    curl -Lf# https://github.com/homebridge/ffmpeg-for-homebridge/releases/download/v2.1.1/ffmpeg-alpine-arm32v7.tar.gz | tar xzf - -C / --no-same-owner && \
    apt-get clean

# Remove the configuration file
RUN rm /etc/apt/apt.conf.d/99allow-insecure-repositories

USER node