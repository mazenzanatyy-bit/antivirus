#!/bin/bash

bad_ext=("exe" "bat" "vbs" "scr" "ps1")
bad_words=("virus" "trojan" "malware" "worm" "ransomware")

is_malicious() {
    local file="$1"
    local name
    name=$(basename "$file")

    if [[ "$name" == *.* ]]; then
        local ext="${name##*.}"
        for e in "${bad_ext[@]}"; do
            if [ "${ext,,}" = "$e" ]; then
                return 0
            fi
        done
    fi

    for w in "${bad_words[@]}"; do
        if grep -qi -- "$w" "$file"; then
            return 0
        fi
    done

    return 1
}
