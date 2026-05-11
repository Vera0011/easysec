#!/bin/bash

set -euo pipefail

## - Available modules - ##
ALL_BLUE_MODULES="lynis,grype,syft,grant,ssl,keycloak"
ALL_BLUE_WORKFLOWS="anchore"
ALL_RED_MODULES="proxychains"
ALL_RED_WORKFLOWS=""

## - General variables (overriden in functions) - ##
CHOICE=""
MODULES=""

## - Colors and fonts - ##
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
CYAN="\033[0;36m"
BLUE="\033[0;34m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
WHITE="\033[1;37m"
LINE="──────────────────────────────────────"

log() {
    # Log function. Displays current time and different colors (based on type, which are: info, success, warn and error)
    # Usage example: log "Hi" success

    local type="${2:-info}"
    local timestamp
    timestamp=$(date '+%H:%M:%S')
    local color

    case "$type" in
        info)    color=$BLUE ;;   # blue
        success) color=$GREEN ;;   # green
        warn)    color=$YELLOW ;;   # yellow
        error)   color=$RED ;;   # red
        *)       color=$WHITE ;;   # white
    esac

    echo -e "${BOLD}${color}[${timestamp}] [${type^^}]${RESET} $1"
}

show_banner() {
    # Displays welcome banner (EasySec)
    clear
    echo -e "${CYAN}"
    cat << 'EOF'
    ███████╗ █████╗ ███████╗██╗   ██╗███████╗███████╗ ██████╗
    ██╔════╝██╔══██╗██╔════╝╚██╗ ██╔╝██╔════╝██╔════╝██╔════╝
    █████╗  ███████║███████╗ ╚████╔╝ ███████╗█████╗  ██║
    ██╔══╝  ██╔══██║╚════██║  ╚██╔╝  ╚════██║██╔══╝  ██║
    ███████╗██║  ██║███████║   ██║   ███████║███████╗╚██████╗
    ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚══════╝ ╚═════╝
EOF
    echo -e "${RESET}"
    echo -e "  ${DIM}by Vera${RESET}\n"
    echo -e "  ${BOLD}${WHITE}Security automation for SMEs${RESET}"
    echo -e "${DIM}"
    cat << 'EOF'
    ─────────────────────────────────────────────────────────────────
    Roles, tools and documentation to help small and medium-sized
    enterprises implement security measures, penetration testing
    and red teaming exercises — idempotent by design.
    ─────────────────────────────────────────────────────────────────
EOF
    echo -e "${RESET}"
}

show_list() {
    # LIst interface - Shows available modules and workflows (at the start of the program)
    clear
    echo -e "\n${DIM}${LINE}${RESET}"
    echo -e "${BOLD}${WHITE}  List - Available resources${RESET}"
    echo -e "${DIM}${LINE}${RESET}\n"
    echo -e "  ${CYAN}Blue team Modules${RESET}   ${DIM}─ ${ALL_BLUE_MODULES}${RESET}"
    echo -e "  ${CYAN}Blue team Workflows${RESET} ${DIM}─ ${ALL_BLUE_WORKFLOWS}${RESET}"
    echo -e ""
    echo -e "  ${CYAN}Red team Modules${RESET}    ${DIM}─ ${ALL_RED_MODULES}${RESET}"
    #echo -e "  ${CYAN}Red team Workflows${RESET}  ${DIM}─ ${ALL_RED_WORKFLOWS}${RESET}"
    echo -e "\n${DIM}${LINE}${RESET}"
}

show_menu() {
    # Menu interface - Displays the current options of this script
    clear
    echo -e "\n${DIM}${LINE}${RESET}"
    echo -e "${BOLD}${WHITE}  Menu - Select modules to provision${RESET}"
    echo -e "${DIM}${LINE}${RESET}\n"
    echo -e "  ${CYAN}1)${RESET} Blue Team   ${DIM}─ Workflows and modules${RESET}"
    echo -e "  ${CYAN}2)${RESET} Red Team    ${DIM}─ Workflows and modules${RESET}"
    echo -e "  ${CYAN}3)${RESET} Specific    ${DIM}─ Enter a module name${RESET}"
    echo -e "  ${CYAN}4)${RESET} List        ${DIM}─ Show all available modules${RESET}"
    echo -e "\n${DIM}${LINE}${RESET}"
    echo -en "\n  Choice [1/2/3/4]: "

    read -r CHOICE
}

show_module_3() {
    # Module 3 interface - Displays the current modules and workflows, and allows to select multiple of them and validates the input
    clear
    local valid_modules="${ALL_BLUE_MODULES},${ALL_RED_MODULES}"
    local valid_workflows="${ALL_BLUE_WORKFLOWS}"
    local all_valid="${valid_modules},${valid_workflows}"
    local errors=()

    echo -e "\n${DIM}${LINE}${RESET}"
    echo -e "${BOLD}${WHITE}  MODULE 3 - Available resources${RESET}"
    echo -e "${DIM}${LINE}${RESET}\n"
    echo -e "  ${CYAN}Modules${RESET}   ${DIM}─ ${ALL_BLUE_MODULES},${ALL_RED_MODULES}${RESET}"
    echo -e "  ${CYAN}Workflows${RESET} ${DIM}─ ${ALL_BLUE_WORKFLOWS}${RESET}" #,${ALL_RED_WORKFLOWS}${RESET}"
    echo -e "\n${DIM}${LINE}${RESET}"
    echo -en "\nEnter comma-separated name(s): "

    # Inputs
    read -r RAW_MODULES
    IFS=',' read -ra REQUESTED <<< "$RAW_MODULES"

    # Validation
    for mod in "${REQUESTED[@]}"; do
        mod="$(echo "$mod" | xargs)"  # trim whitespace

        if [[ -z "$mod" ]]; then
            continue
        fi
        if [[ ",${all_valid}," != *",${mod},"* ]]; then
            errors+=("$mod")
            continue
        fi

        # Appends correctly value (validating if non-first to add the ',')
        if [[ -n "$MODULES" ]]; then
            MODULES+=",$mod"
        else
            MODULES+="$mod"
        fi
    done

    if [[ ${#errors[@]} -gt 0 ]]; then
        log "Unknown module(s): ${errors[*]}" error
        return 1
    fi

    return 0
}

## - Input - ##
show_banner
sleep 2

while true; do
    show_menu

    case "$CHOICE" in
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
vagrant up --provision-with shell --parallel && \
    CUSTOM_MODULES=$MODULES vagrant provision --provision-with ansible