#!/bin/bash

######################################################################################
# This script generates RSA keys to share access between instances (used by Vagrant) #
######################################################################################

cd "$(dirname "$0")/.." && \
    mkdir -p ./vagrant && \
    if [ ! -f ./vagrant/id_rsa ]; then
        ssh-keygen -t rsa -C vagrant -f ./vagrant/id_rsa -N ""
    else
        echo "RSA keys already exist, skipping generation."
    fi