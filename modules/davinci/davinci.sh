#! /bin/bash

wordlist="$2"
type="$3"
tempfile=false
if [ -f "$1" ]; then
    hashfile="$1"
else
    hashfile=$(mktemp)
    echo "$1" > "$hashfile"
    tempfile=true
fi

case "$type" in
    md5) mode=0 ;;
    sha1) mode=100 ;;
    sha256) mode=1400 ;;
    sha512) mode=1700 ;;
    *)
    echo "[ERROR] Unsupported hash type: $type"
    echo "Supported types:"
    echo " md5"
    echo " sha1"
    echo " sha256"
    echo " sha512"
    exit 1 ;;
esac

hashcat -m "$mode" -a 0 "$hashfile" "$wordlist" --quiet --potfile-disable > /dev/null
result=$(hashcat -m "$mode" --show "$hashfile")

if [ -z "$result" ]; then
    echo "[INFO] No passwords cracked."
else
    echo "$result" | while IFS=: read -r hash password rest; do
        echo "[CRACKED] $hash -> $password"
    done
fi

if [ "$tempfile" = true ]; then
    rm "$hashfile"
fi