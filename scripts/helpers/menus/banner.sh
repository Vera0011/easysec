#!/bin/bash

###########################################
# This script contains the startup banner #
#                                         #
# Author: Vera                 13/08/2026 #
###########################################

source scripts/helpers/io.sh
source scripts/helpers/fonts.sh

# Displays welcome banner (EasySec)
display_banner() {
    clear
    lock_input
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