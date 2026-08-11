#!/bin/bash

source helpers/fonts.sh

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

lock_input() {
    # This function locks the input available for the user (to avoid discrepancies with the interface)
    stty -echo -icanon
}

unlock_input() {
    # This function unlocks the input available for the user (to avoid discrepancies with the interface)
    read -r -d '' -t 0.1 FLUSH || true
    stty echo icanon
}