#!/bin/sh

echo "" >> build.info || true
echo "Build-Info ${1}:" >> build.info || true
echo "==============================" >> build.info || true
cat "/etc/os-release" >> build.info || true
echo "git ${2}" >> build.info || true
echo "node $(node -v)" >> build.info || true
# problems running npm for arm under qemu with node:20-alpine image:
if [ "$(sed -rn 's|^ID=||p' /etc/os-release)" = "alpine" ] && [ "$(uname -m)" = "armv7l" ]; then
  echo "no npm info available" >> build.info || true
else
  echo "npm $(npm -v)" >> build.info || true
fi
