#!/bin/bash

# Install docker on the host machine and set up the docker environment for kind cluster

# 1. Install Docker
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl enable --now docker
else
    echo "Docker is already installed."
fi

# 2. Set up user permissions
sudo usermod -aG docker $USER

echo "------------------------------------------------------------------"
echo "Done! To apply group changes immediately, run: newgrp docker"
echo "------------------------------------------------------------------"
