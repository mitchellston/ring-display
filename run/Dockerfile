FROM karsten13/magicmirror:v2.25.0

USER root

# Update apt configuration to disable signature verification
RUN echo 'Acquire::AllowInsecureRepositories "true";' > /etc/apt/apt.conf.d/99allow-insecure-repositories

# Install required packages
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install --allow-unauthenticated -y gnupg curl
RUN apt-get clean

# Download and extract ffmpeg
RUN curl -Lf https://github.com/homebridge/ffmpeg-for-homebridge/releases/download/v2.1.1/ffmpeg-alpine-arm32v7.tar.gz | tar xzf - -C / --no-same-owner

# Remove the configuration file
RUN rm /etc/apt/apt.conf.d/99allow-insecure-repositories

USER node