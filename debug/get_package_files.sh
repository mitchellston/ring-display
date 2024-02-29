#!/bin/bash

set -e

docker cp mm:/opt/magic_mirror/package.json /mnt/z/foreign/MagicMirror/
docker cp mm:/opt/magic_mirror/package-lock.json /mnt/z/foreign/MagicMirror/

docker cp mm:/opt/magic_mirror/vendor/package.json /mnt/z/foreign/MagicMirror/vendor/
docker cp mm:/opt/magic_mirror/vendor/package-lock.json /mnt/z/foreign/MagicMirror/vendor/

docker cp mm:/opt/magic_mirror/fonts/package.json /mnt/z/foreign/MagicMirror/fonts/
docker cp mm:/opt/magic_mirror/fonts/package-lock.json /mnt/z/foreign/MagicMirror/fonts/

