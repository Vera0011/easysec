#!/bin/bash

source helpers/io.sh
source helpers/fonts.sh
source helpers/shared_variables.sh

# Display available modules and workflows
display_modules_and_workflows() {
    clear
    lock_input
    echo -e "\n${DIM}${LINE}${RESET}"
    echo -e "${BOLD}${WHITE}  List - Available resources${RESET}"
    echo -e "${DIM}${LINE}${RESET}\n"
    echo -e "  ${CYAN}Blue team Modules${RESET}   ${DIM}─ ${ALL_BLUE_MODULES//,/, }${RESET}"
    echo -e "  ${CYAN}Blue team Workflows${RESET} ${DIM}─ ${ALL_BLUE_WORKFLOWS//,/, }${RESET}"
    echo -e ""
    echo -e "  ${CYAN}Red team Modules${RESET}    ${DIM}─ ${ALL_RED_MODULES//,/, }${RESET}"
    #echo -e "  ${CYAN}Red team Workflows${RESET}  ${DIM}─ ${ALL_RED_WORKFLOWS}${RESET}"
    echo -e "\n${DIM}${LINE}${RESET}"
}