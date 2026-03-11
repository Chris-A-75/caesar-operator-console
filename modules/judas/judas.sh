#! /bin/bash

# WRITTEN BY
#  ________
# /        \
# | b1smrk |
# \________/
#                                      |__
#                                      |\/
#                                      ---
#                                      / | [
#                               !      | |||
#                             _/|     _/|-++'
#                         +  +--|    |--|--|_ |-
#                      { /|__|  |/\__|  |--- |||__/
#                     +---------------___[}-_===_.'____                 /\
#                 ____`-' ||___-{]_| _[}-  |     |_[___\==--            \/   _
#  __..._____--==/___]_|__|_____________________________[___\==--____,------' .7
# |                                                                          /
#  \_________________________________________________________________________|

usage() {
    echo "Usage: $0 [options] <IP_ADDRESS>"
    echo "-h: open the help page"
    echo "-f: specify the file containing the list of directories (one directory per line)"
    exit 1
}

while getopts 'hf:' flag; do
        case "$flag" in
        h) usage ;;
        f) file="$OPTARG" ;;
        *) usage ;;
        esac
done

shift $((OPTIND-1))

if [ -z "$1" ]; then
    echo "Error: No IP address provided."
    usage
    exit 1
fi

address=$1

if [ -z "$file" ]; then
    echo "Error: No file directory provided."
    usage
    exit 1
fi

if [ ! -f "$file" ]; then
    echo "Error: File not found."
    usage
    exit 1
fi

while IFS= read -r line; do
    url="http://$address/$line"
    response=$(curl -s "$url" | grep -io "flag[^<]*") # will continue until it encounters "<"
    if [ -n "$response" ]; then
        echo "Flag found at: $url"
        echo "Response: $response"
    fi
done < "$file"