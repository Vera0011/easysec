#!/bin/bash

vagrant up --provision-with shell --parallel && \
vagrant provision --provision-with ansible