#!/bin/bash

# TODO: move this to a Dockerfile, so that a container is spawned to managing the cluster

wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq

apt update && apt install nano jq ansible

ansible-galaxy collection install ansible.posix
