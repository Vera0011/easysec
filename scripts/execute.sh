#!/bin/bash

# Moves execution path to scripts location
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]:-$0}")"
cd "$(dirname "$SCRIPT_PATH")" || exit 1

source helpers/io.sh
source helpers/menus.sh
source helpers/shared_variables.sh

set -euo pipefail

mkdir -p generated

## - Module selection - ##
display_banner
sleep 2

while true; do
    display_main_menu

    case "$MAIN_MENU_CHOICE" in
        1)
            MODULES="${ALL_BLUE_MODULES},${ALL_BLUE_WORKFLOWS}"
            log "Loaded blue team modules and workflows" success
            break
            ;;
        2)
            MODULES="${ALL_RED_MODULES}"
            log "Loaded red team modules and workflows" success
            break
            ;;
        3)
            until select_modules_and_workflows; do
                log "Please try again." warn
                sleep 2
            done
            log "Loaded custom modules and workflows" success
            break
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

## - Environment selection - ##
while true; do
    show_menu

    case "$ENVIRONMENT_MENU_CHOICE" in
        1)
            MODULES="${ALL_BLUE_MODULES},${ALL_BLUE_WORKFLOWS}"
            log "Loaded blue team modules and workflows" success
            break
            ;;
        2)
            MODULES="${ALL_RED_MODULES}"
            log "Loaded red team modules and workflows" success
            break
            ;;
        3)
            until show_module_3; do
                log "Please try again." warn
                sleep 2
            done
            log "Loaded custom modules and workflows" success
            break
            ;;
        4)
            show_list
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

## - Execution - ##
export CUSTOM_MODULES=$MODULES
vagrant up --provision-with shell --parallel && \
    vagrant provision --provision-with ansible