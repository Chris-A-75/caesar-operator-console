#! /bin/bash

host="$1"
port="$2"
file="$3"

address="$host:$port"

./modules/judas/judas.sh -f "$file" "$address"