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

scan_dir() {
    local dir="$1"
    local mal_dir="$2"

    for file in "$dir"/*; do
        [ -f "$file" ] || continue

        if is_malicious "$file"; then
            echo "$(basename "$file") is malicious and is deleted "
            cp "$file" "$mal_dir/"
            rm "$file"
        fi
    done
}

if [ $# -ne 3 ]; then
    echo "Usage: $0 dir malicious_dir interval-secs"
    exit 1
fi

dir="$1"
mal_dir="$2"
interval="$3"

if [ ! -f directory-info.last ]; then
    scan_dir "$dir" "$mal_dir"
    ls -l "$dir" > directory-info.last
fi

while true; do
    sleep "$interval"
    ls -l "$dir" > directory-info.new
    if ! diff -q directory-info.last directory-info.new > /dev/null; then
        scan_dir "$dir" "$mal_dir"
        cp directory-info.new directory-info.last
    fi
done
