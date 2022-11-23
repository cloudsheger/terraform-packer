#! /usr/bin/env bash

set -e

# Helps clear issues of not finding Ansible package,
# perhaps due to updates running when server is first spun up
sleep 10

export DEBIAN_FRONTEND="noninteractive"

sudo apt-get update
sudo apt-get install \
    ca-certificates \
    dialog apt-utils \
    curl \
    gnupg \
    git \
    lsb-release -y
# Add Docker’s official GPG key:    
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# set up repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# install docker
sudo apt-get update
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
docker --version
echo "Docker installation completed"

# Install Docker compose
echo "Installing docker compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
git --version 

echo "Docker-compose installation completed"