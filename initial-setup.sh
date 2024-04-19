# Setup ssh server
sudo apt-get update
sudo apt-get install openssh-server -y
sudo systemctl enable ssh
sudo systemctl start ssh

# Docker install
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update

# Docker extension install
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

cp "$(dirname "$0").env.example" "$(dirname "$0").env"

# Docker post-install
sudo usermod -aG docker $USER
newgrp docker

# Export display (display is first screen on host machine from xauth list)
export DISPLAY=$(echo $DISPLAY | cut -d: -f1)
