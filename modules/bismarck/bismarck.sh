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

port_provided=''

usage() {
	echo "Usage: $0 [optional arguments] <destination_ip_address>"
	echo "-h: open the help page"
	echo "-p <port ranges>: only scan specified ports (example: -p 22, -p 20-1000)"
	exit 1
}


# parse command-line arguments
while getopts 'p:h' flag; do
	case "$flag" in
	p) port_provided="${OPTARG}" ;;
	h) usage ;;
	*) usage ;;
	esac
done

shift $((OPTIND -1)) # get rid of all optional arguments so that provided ip address goes in $1

# check if user provided destination IP address
if [ -z "$1" ]; then
    usage
    exit 1
fi

is_open() {
	local ip="$1"
	local port="$2"
	nc -nvz "$ip" "$port" 2>/dev/null
	# netcat returns 0 if connection is open, 1 if closed/filtered (can check this with 'echo $?')
}

grab_banner() {
	local ip="$1"
	local port="$2"
	timeout 0.2 nc -nv "$ip" "$port" </dev/null
}


scan_port() {
	local ip="$1"
	local port="$2"
	if is_open "$ip" "$port"; then
		echo "OPEN $port"
		grab_banner "$ip" "$port"
	fi
}

if [ -n "$port_provided" ]; then
	if [[ "$port_provided" =~ ^[0-9]+-[0-9]+$ ]]; then #check if range (thank you regex ^-^)
		range_start="${port_provided%-*}"
		range_end="${port_provided#*-}" # parses range
		
		for p in $(seq "$range_start" "$range_end"); do
			scan_port "$1" "$p" # scans for each port in range
		done
	else # scan single port
		scan_port "$1" "$port_provided"
	fi
else # no port provided, scan everything
	for p in {1..65535}; do
		scan_port "$1" "$p"
	done
fi
