#!/bin/bash

# Groups keys by values (dicts). Used to display and manage available modules and workflows
group_by_value() {
    local -n arr="$1"
    local -A groups=()

    for key in "${!arr[@]}"; do
        local val="${arr[$key]}"
        if [[ -v groups[$val] ]]; then
            groups[$val]+=", $key"
        else
            groups[$val]="$key"
        fi
    done

    for val in "${!groups[@]}"; do
        echo "${val} - ${groups[$val]}"
    done
}

# Returns comma-separated keys from an associative array whose value matches $2
keys_by_value() {
    local -n arr="$1"
    local target="$2"
    local result=""

    for key in "${!arr[@]}"; do
        if [[ "${arr[$key]}" == "$target" ]]; then
            if [[ -n "$result" ]]; then
                result+=",$key"
            else
                result="$key"
            fi
        fi
    done

    echo "$result"
}

# Retrieves all modules and workflows for red team
get_all_red_team() {
    local modules=$(keys_by_value MODULES "Red team")
    local workflows=$(keys_by_value WORKFLOWS "Red team")
    local result=""

    if [[ -n "$modules" ]]; then
        if [[ -n "$result" ]]; then
            result+=",${modules}"
        else
            result="${modules}"
        fi
    fi

    if [[ -n "$workflows" ]]; then
        if [[ -n "$result" ]]; then
            result+=",${workflows}"
        else
            result="${workflows}"
        fi
    fi

    echo "$result"
}

# Retrieves all modules and workflows for blue team
get_all_blue_team() {
    local modules=$(keys_by_value MODULES "Blue team")
    local workflows=$(keys_by_value WORKFLOWS "Blue team")
    local result=""

    if [[ -n "$modules" ]]; then
        if [[ -n "$result" ]]; then
            result+=",${modules}"
        else
            result="${modules}"
        fi
    fi

    if [[ -n "$workflows" ]]; then
        if [[ -n "$result" ]]; then
            result+=",${workflows}"
        else
            result="${workflows}"
        fi
    fi

    echo "$result"
}