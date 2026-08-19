#!/bin/bash

####################################################
# This file contains variables used in all scripts #
#                                                  #
# Author: Vera                          13/08/2026 #
####################################################

set -euo pipefail

## - Configuration variables - ##
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/$(date +%s).log"

## - Available modules and workflows - ##
declare -A MODULES=(
    ["lynis"]="Blue team"
    ["grype"]="Blue team"
    ["syft"]="Blue team"
    ["grant"]="Blue team"
    ["ssl"]="Blue team"
    ["postgresql"]="Blue team"
    ["proxychains"]="Red team"
)

declare -A WORKFLOWS=(
    ["anchore"]="Blue team"
    ["keycloak"]="Blue team"
    ["audit"]="Blue team"
    ["hardening"]="Blue team"
)

declare -A PLAYBOOK_TO_MODULES=(
    ["anchore"]="workflows/anchore.yml"
    ["keycloak"]="workflows/keycloak.yml"
    ["lynis"]="playbooks/lynis.yml"
    ["grype"]="playbooks/grype.yml"
    ["syft"]="playbooks/syft.yml"
    ["grant"]="playbooks/grant.yml"
    ["ssl"]="playbooks/ssl.yml"
    ["postgresql"]="playbooks/postgresql.yml"
    ["audit"]="workflows/audit.yml"
    ["proxychains"]="playbooks/proxychains.yml"
    ["hardening"]="workflows/hardening.yml"
)

## - Available environments - ##
declare -A ALL_ENVIRONMENTS=(
    ["production"]="Will use the hosts located in inventory/production."
    ["staging"]="Will use the hosts located in inventory/staging."
    ["testing"]="Will use the hosts located in inventory/vagrant. Vagrant has to be set up."
)

declare -A ALL_INVENTORY_PATHS=(
    ["production"]="inventory/production"
    ["staging"]="inventory/staging"
)

## - Choice variables (overriden in functions) - ##
MAIN_MENU_CHOICE=""
ENVIRONMENT_MENU_CHOICE=""

## - Cleaned outputs (to be used in the execution) - ##
CLEAN_MODULES=""
CLEAN_ENVIRONMENT=""
CLEAN_INV_PATH=""