#! /bin/bash

host="$1"
port="$2"
file="$3"
keyword="$4"
scheme="$5"

address="$host:$port"

if [ -n "$scheme" ]; then
    ./modules/judas/judas.sh -f "$file" -k "$keyword" -s "$scheme" "$address"
else
    ./modules/judas/judas.sh -f "$file" -k "$keyword" "$address"
fi
