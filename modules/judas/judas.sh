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
    echo "-k: specify the keyword to search for"
    echo "-s: specify the scheme to use (http or https)"
    exit 1
}

scheme="http"

while getopts 'hf:k:s:' flag; do
        case "$flag" in
        h) usage ;;
        f) file="$OPTARG" ;;
        k) keyword="$OPTARG" ;;
        s) scheme="$OPTARG" ;;
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

if [ -z "$keyword" ]; then
    echo "Error: No keyword provided."
    usage
    exit 1
fi

if [ "$scheme" != "http" ] && [ "$scheme" != "https" ]; then
    echo "Error: Invalid scheme. Use http or https."
    usage
    exit 1
fi

while IFS= read -r line; do
    url="$scheme://$address/$line"
    response=$(curl -s "$url" | grep -iF "$keyword")
    if [ -n "$response" ]; then
        echo "Keyword found at: $url"
        echo "Response: $response"
    fi
done < "$file"
