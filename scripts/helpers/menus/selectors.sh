#!/bin/bash

source helpers/io.sh
source helpers/fonts.sh
source helpers/shared_variables.sh

# Displays the current modules and workflows, and allows to select multiple of them and validates the input
select_modules_and_workflows() {
    clear
    lock_input
    local valid_modules="${ALL_BLUE_MODULES},${ALL_RED_MODULES}"
    local valid_workflows="${ALL_BLUE_WORKFLOWS}"
    local all_valid="${valid_modules},${valid_workflows}"
    local errors=()

    echo -e "\n${DIM}${LINE}${RESET}"
    echo -e "${BOLD}${WHITE}  MODULE 3 - Available resources${RESET}"
    echo -e "${DIM}${LINE}${RESET}\n"
    echo -e "  ${CYAN}Modules${RESET}   ${DIM}─ ${ALL_BLUE_MODULES//,/, }, ${ALL_RED_MODULES//,/, }${RESET}"
    echo -e "  ${CYAN}Workflows${RESET} ${DIM}─ ${ALL_BLUE_WORKFLOWS//,/, }${RESET}" #,${ALL_RED_WORKFLOWS}${RESET}"
    echo -e "\n${DIM}${LINE}${RESET}"
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

select_environments() {

}