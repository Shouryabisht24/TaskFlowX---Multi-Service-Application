#!/bin/bash

# Install kubectl on your env

# Variable
Version="v1.36.0"
URL="https://dl.k8s.io/release/${Version}/bin/linux/amd64/kubectl"
Install_Dir="/usr/local/bin"

# Download & Install kubectl

curl -LO "$URL"
chmod +x kubectl
sudo mv kubectl $Install_Dir/
kubectl version --client

# Clean up
rm -f kubectl

echo "kubectl installation complete."