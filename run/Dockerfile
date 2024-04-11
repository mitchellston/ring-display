ARG NODE_VERSION=20
ARG MAGICMIRROR_VERSION=2.27.0
ARG BUN_VERSION=1.1.3
ARG FFMPEG_VERSION=2.1.1

FROM node:$NODE_VERSION-bookworm AS node

FROM debian:bookworm-slim

ARG MAGICMIRROR_VERSION
ARG FFMPEG_VERSION
ARG BUN_VERSION

# Install gnupg
RUN apt update; \ 
    apt install -y gpgconf gpg gnupg-utils gnupg-l10n

RUN apt install -y libcanberra-gtk-module libcanberra-gtk3-module

# Install curl
RUN apt update && apt install -y curl

# Download and extract ffmpeg
RUN curl -Lf https://github.com/homebridge/ffmpeg-for-homebridge/releases/download/v${FFMPEG_VERSION}/ffmpeg-alpine-arm32v7.tar.gz | tar xzf - -C / --no-same-owner

# Install git + nano
RUN apt install -y git nano

# Electron deps
RUN apt-get -y install libgtkextra-dev libgbm-dev libgconf2-dev libnss3 libasound2 libxtst-dev libxss1

# Install Nodejs
COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/share /usr/local/share
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin


# Install Bun
RUN npm install -g bun@1.1.3

# Clone magic mirror
RUN cd /opt; \ 
    git clone --depth 1 --branch v${MAGICMIRROR_VERSION} https://github.com/MagicMirrorOrg/MagicMirror.git magic_mirror

WORKDIR /opt/magic_mirror

# Setup magic mirror
RUN bun install

ENV ELECTRON_DISABLE_GPU=1