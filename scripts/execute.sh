#!/bin/bash

########################################################
# This file is the main entry for starting the program #
#                                                      #
# Author: Vera                              13/08/2026 #
########################################################

set -euo pipefail

# Moves execution path to scripts location
MAIN_PATH="$(readlink -f "${BASH_SOURCE[0]:-$0}")"
SCRIPT_DIR="$(dirname "$MAIN_PATH")"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT" || exit 1

source scripts/helpers/io.sh
source scripts/helpers/menus.sh
source scripts/helpers/shared_variables.sh
source scripts/helpers/helper.sh

mkdir -p generated $LOG_DIR

## - Module selection - ##
display_banner
sleep 2

while true; do
    display_main_menu

    case "$MAIN_MENU_CHOICE" in
        1)
            CLEAN_MODULES=$(get_all_blue_team)
            log "Loaded blue team modules and workflows" success
            break
            ;;
        2)
            CLEAN_MODULES=$(get_all_red_team)
            log "Loaded red team modules and workflows" success
            break
            ;;
        3)
            until select_modules_and_workflows; do
                log "Please try again." warn
                sleep 2
            done
            
            if [[ "$CLEAN_MODULES" != "5" ]]; then
                log "Loaded custom modules and workflows" success
                break
            fi
            ;;
        4)
            display_modules_and_workflows
            sleep 5
            ;;
        5)
            log "Exiting EasySec" info
            exit 1
            ;;
        *)
            log "Invalid option" error
            sleep 2
            ;;
    esac
done

sleep 2

## - Environment selection - ##
while true; do
    until select_environment; do
        log "Please try again." warn
        sleep 2
    done

    if [[ "$CLEAN_ENVIRONMENT" == "5" ]]; then
        log "Exiting EasySec" info
        exit 1
    fi

    break
done

## - Execution - ##
if [[ -z $CLEAN_INV_PATH ]]; then
    export CUSTOM_MODULES=$CLEAN_MODULES
    vagrant up --provision-with shell --parallel && \
    vagrant provision --provision-with ansible
else
    IFS=',' read -ra MODULE_LIST <<< "$CLEAN_MODULES"

    for module in ${MODULE_LIST}; do
        ansible-playbook -i $CLEAN_INV_PATH "${PLAYBOOK_TO_MODULES[$module]}"
        
        log "Executed playbook for $module" info
        sleep 2
    done
fi