ARG NODE_VERSION=20
ARG MAGICMIRROR_VERSION=2.27.0
ARG FFMPEG_VERSION=2.1.1
ARG YARN_VERSION=1.22.22

FROM node:$NODE_VERSION-bookworm 

ARG MAGICMIRROR_VERSION
ARG FFMPEG_VERSION
ARG YARN_VERSION

# install electron dependencies or more if your library has other dependencies
RUN apt-get update && apt-get install \
    libx11-xcb1 libxcb-dri3-0 libcanberra-gtk-module libcanberra-gtk3-module libxtst6 libgl1-mesa-dri libnss3 libatk-bridge2.0-0 libgtk-3-0 libxss1 libasound2 \
    -yq --no-install-suggests --no-install-recommends \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install curl
RUN apt update && apt install -y curl

# Download and extract ffmpeg
RUN curl -Lf https://github.com/homebridge/ffmpeg-for-homebridge/releases/download/v${FFMPEG_VERSION}/ffmpeg-alpine-x86_64.tar.gz | tar xzf - -C / --no-same-owner

# Install git + nano
RUN apt install -y git nano

# Electron deps
RUN apt-get -y install libgtkextra-dev libgbm-dev libgconf2-dev libnss3 libasound2 libxtst-dev libxss1

RUN apt-get -y install dbus; \
    dbus-uuidgen > /var/lib/dbus/machine-id; \
    chown -R node: /run/dbus

# Install Bun
RUN npm install -g yarn@${YARN_VERSION} --force

RUN chown -R node: /opt

USER node

RUN mkdir -p /var/run/dbus; \
    dbus-daemon --system &> /dev/null

# Clone magic mirror
RUN cd /opt; \ 
    git clone --depth 1 --branch v${MAGICMIRROR_VERSION} https://github.com/MagicMirrorOrg/MagicMirror.git magic_mirror

WORKDIR /opt/magic_mirror

# Setup magic mirror
RUN bun install

RUN npx electron-rebuild

# Electron needs root for sand boxing
# see https://github.com/electron/electron/issues/17972
USER root
RUN chown root /opt/magic_mirror/node_modules/electron/dist/chrome-sandbox
RUN chmod 4755 /opt/magic_mirror/node_modules/electron/dist/chrome-sandbox

# Runtime start script
COPY runtime-start.sh /opt/magic_mirror/runtime-start.sh
RUN chmod 777 /opt/magic_mirror/runtime-start.sh

USER node

# ENV DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

CMD ["/bin/bash", "-c", "/opt/magic_mirror/runtime-start.sh"]