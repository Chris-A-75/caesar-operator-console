#! /bin/bash

target="$1"
port="$2"

if [ -n "$port" ]; then
    ./modules/bismarck/bismarck.sh -p "$port" "$target"
else
    ./modules/bismarck/bismarck.sh "$target"
fi