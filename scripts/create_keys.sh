#!/bin/bash

###########################################################################################
# This script generates RSA keys to share access between instances (used only by Vagrant) #
#                                                                                         #
# Author: Vera                                                                 13/08/2026 #
###########################################################################################

cd "$(dirname "$0")/.." && \
    mkdir -p ./vagrant && \
    if [ ! -f ./vagrant/id_rsa ]; then
        ssh-keygen -t rsa -C vagrant -f ./vagrant/id_rsa -N ""
    else
        echo "RSA keys already exist, skipping generation."
    fi