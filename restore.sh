#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 dir malicious_dir"
    exit 1
fi

dir="$1"
mal_dir="$2"

while true; do
    files=()
    for f in "$mal_dir"/*; do
        [ -f "$f" ] && files+=("$(basename "$f")")
    done

    if [ ${#files[@]} -eq 0 ]; then
        echo "No malicious files to review."
        exit 0
    fi

    echo "Quarantined files:"
    for i in "${!files[@]}"; do
        echo "$((i+1))) ${files[$i]}"
    done
    echo "0) Quit"

    read -p "Pick a file number: " pick

    if [ "$pick" = "0" ]; then
        exit 0
    fi

    if ! [[ "$pick" =~ ^[0-9]+$ ]] || [ "$pick" -lt 1 ] || [ "$pick" -gt ${#files[@]} ]; then
        echo "Invalid choice."
        continue
    fi

    file="${files[$((pick-1))]}"

    echo "1) Restore $file to $dir (false positive)"
    echo "2) Permanently delete $file (genuinely malicious)"
    echo "3) Leave it and go back to the list"
    read -p "Choose 1, 2 or 3: " action

    case "$action" in
        1)
            mv "$mal_dir/$file" "$dir/"
            echo "Restored $file to $dir."
            ;;
        2)
            rm "$mal_dir/$file"
            echo "$file permanently deleted."
            ;;
        3)
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
done
