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
    echo "Usage: $0 <domain_name>"
    echo "-h: open the help page"
    exit 1
}

while getopts 'h' flag; do
        case "$flag" in
        h) usage ;;
        *) usage ;;
        esac
done

if [ -z "$1" ]; then
    usage
    exit 1
fi

domain="$1"

dns=$(host -t ns "$domain" | cut -d ' ' -f 4)
for server in $dns; do
    answer=$(host -l "$domain" "$server")
    if echo "$answer" | grep -qi "refused"; then
        echo "Zone transfer refused by $server"
    else
        echo "Zone transfer successful with $server"
        echo "$answer" | grep "has address"
    fi
done