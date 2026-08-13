#!/bin/bash

############################################################################
# This script contains all menus (that allows selections) from the program #
#                                                                          #
# Author: Vera                                                  13/08/2026 #
############################################################################

source scripts/helpers/io.sh
source scripts/helpers/fonts.sh
source scripts/helpers/shared_variables.sh

# Displays the current modules and workflows, and allows to select multiple of them and validates the input
select_modules_and_workflows() {
    clear
    lock_input
    local errors=()

    # Display
    echo -e "\n${DIM}${LINE}${RESET}"
    echo -e "${BOLD}${WHITE}  List - Available resources${RESET}"
    echo -e "${DIM}${LINE}${RESET}\n"

    echo -e "  ${CYAN}Modules${RESET}"
    while IFS= read -r line; do
        echo -e "    ${DIM}─ ${line}${RESET}"
    done < <(group_by_value MODULES)

    echo -e ""
    echo -e "  ${CYAN}Workflows${RESET}"
    while IFS= read -r line; do
        echo -e "    ${DIM}─ ${line}${RESET}"
    done < <(group_by_value WORKFLOWS)

    echo -e "\n${DIM}${LINE}${RESET}"
    echo -e "\n${DIM}${CYAN}${ITALIC}Note: You can quit this menu by pressing 5 and enter${RESET}"
    echo -en "\nEnter comma-separated name(s): "

    # Inputs
    unlock_input
    read -r RAW_MODULES
    lock_input
    IFS=',' read -ra REQUESTED <<< "$RAW_MODULES"

    # Validation
    for mod in "${REQUESTED[@]}"; do
        mod="$(echo "$mod" | xargs)"  # trim whitespace

        if [[ -z "$mod" ]]; then
            continue
        fi
        
        if [[ "$mod" == "5" ]]; then
            CLEAN_MODULES="5"
            log "Exiting current menu" info
            return 0
        fi

        if [[ -v MODULES[$mod] || -v WORKFLOWS[$mod] ]]; then
            if [[ -n "$CLEAN_MODULES" ]]; then
                CLEAN_MODULES+=",$mod"
            else
                CLEAN_MODULES+="$mod"
            fi
        else
            errors+=("$mod")
        fi
    done

    if [[ ${#errors[@]} -gt 0 ]]; then
        log "Unknown module(s): ${errors[*]}" error
        return 1
    fi

    return 0
}

select_environment() {
    clear
    lock_input

    echo -e "\n${DIM}${LINE}${RESET}"
    echo -e "${BOLD}${WHITE} List - Available environments${RESET}"
    echo -e "${DIM}${LINE}${RESET}\n"

    for env in "${!ALL_ENVIRONMENTS[@]}"; do
        printf "  ${CYAN}%-12s${RESET} ${DIM}─ %s${RESET}\n" "$env" "${ALL_ENVIRONMENTS[$env]}"
    done

    echo -e "\n${DIM}${LINE}${RESET}"
    echo -e "\n${DIM}${CYAN}${ITALIC}Note: You can quit this menu by pressing 5 and enter${RESET}"
    echo -en "\nEnter environment name: "

    # Input
    unlock_input
    read -r RAW_ENVIRONMENT
    lock_input

    # Trim whitespace
    CLEAN_ENVIRONMENT=$(echo "$RAW_ENVIRONMENT" | xargs)

    if [[ "$CLEAN_ENVIRONMENT" == "5" ]]; then
        log "Exiting current menu" info
        return 0
    fi

    if [[ -z "$CLEAN_ENVIRONMENT" ]]; then
        log "No environment provided" error
        return 1
    fi

    if [[ ! -v ALL_ENVIRONMENTS[$CLEAN_ENVIRONMENT] ]]; then
        log "Unknown environment: ${CLEAN_ENVIRONMENT}" error
        return 1
    fi

    if [[ "${ALL_ENVIRONMENTS[$CLEAN_ENVIRONMENT]}" != "testing" ]]; then
        CLEAN_INV_PATH="${ALL_INVENTORY_PATHS[$CLEAN_ENVIRONMENT]}"
    fi

    return 0
}