#!/bin/bash

################################################
# This script displays the main menu (options) #
#                                              #
# Author: Vera                      13/08/2026 #
################################################

set -euo pipefail

source scripts/helpers/io.sh
source scripts/helpers/fonts.sh
source scripts/helpers/shared_variables.sh

display_main_menu() {
    # Menu interface - Displays the current options of this script
    clear
    lock_input
    echo -e "\n${DIM}${LINE}${RESET}"
    echo -e "${BOLD}${WHITE}  Menu - Select modules to provision${RESET}"
    echo -e "${DIM}${LINE}${RESET}\n"
    echo -e "  ${CYAN}1)${RESET} Blue Team   ${DIM}─ Workflows and modules${RESET}"
    echo -e "  ${CYAN}2)${RESET} Red Team    ${DIM}─ Workflows and modules${RESET}"
    echo -e "  ${CYAN}3)${RESET} Specific    ${DIM}─ Enter a module name${RESET}"
    echo -e "  ${CYAN}4)${RESET} List        ${DIM}─ Show all available modules${RESET}"
    echo -e "  ${CYAN}5)${RESET} Exit        ${DIM}─ Exit the program${RESET}"
    echo -e "\n${DIM}${LINE}${RESET}"
    echo -en "\n  Choice [1/2/3/4/5]: "

    unlock_input
    read -r MAIN_MENU_CHOICE
    lock_input
}