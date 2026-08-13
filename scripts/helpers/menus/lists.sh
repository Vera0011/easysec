#!/bin/bash

########################################################################
# This script contains all menus (that display lists) from the program #
#                                                                      #
# Author: Vera                                              13/08/2026 #
########################################################################

source scripts/helpers/io.sh
source scripts/helpers/fonts.sh
source scripts/helpers/shared_variables.sh
source scripts/helpers/helper.sh

# Display available modules and workflows
display_modules_and_workflows() {
    clear
    lock_input
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
}