#!/bin/bash

# Installing Kind on your environment (AMD64 / x86_64)

[ "$(uname -m)" = "x86_64" ] && \
  curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-$(uname)-amd64 && \
  chmod +x ./kind && \
  sudo mv ./kind /usr/local/bin/
