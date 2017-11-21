#!/bin/bash

#    kernel.org changelog shell parser v0.1"
#    Copyright (C) 2017 Marcus Hoffren.
#    License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
#    This is free software: you are free to change and redistribute it.
#    There is NO WARRANTY, to the extent permitted by law.
#
#    Written by Marcus Hoffren. marcus@harikazen.com

version() {
    echo "kernel.org changelog shell parser v0.1"
    echo "Copyright (C) 2017 Marcus Hoffren."
    echo "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    echo "This is free software: you are free to change and redistribute it."
    echo "There is NO WARRANTY, to the extent permitted by law."
    echo ""
    echo "Written by Marcus Hoffren. marcus@harikazen.com"
    echo ""
}

usage() {
    echo "Usage: ${0##*/} [-h|--help] [-v|--version] <-k|--kernel <version>> [int]"
    echo ""
    echo "-h, --help              Display this help"
    echo "-v, --version           Display version and exit"
    echo ""
    echo "OPTIONS"
    echo ""
    echo "-k, --kernel <kernel>   Kernel version in format"
    echo "                        <1-9>[1-9].<1-9>[1-9].<1-9>[1-9]"
    echo "int                     Commit# (in order of appearance)"
    echo ""
    echo "Required option is --kernel, and optionally an integer"
    echo ""
}

error() {
    { echo -e "\n\e[91m*\e[0m ${@}\n" 1>&2; exit 1; }
}

missing() {
    [[ $(type -p "${1}") ]] || { error "${1} is missing. Install \033[1m${2}\033[m"; exit 1; }
}


### <sanity_check>

[[ "${BASH_VERSION}" < 4.2 ]] && error "${0##*/} requires \033[1mbash v4.4\033[m or newer"

missing "curl" "curl is missing"
missing "awk" "awk is missing"
missing "getopt" "gnu getopt is missing"

unset missing

### </sanity_check>

### <script_arguments>

{ OPTS=$(getopt -nkcp.sh -a -o "vk:h" -l "version,kernel:,help" -- "${@}") || error "getopt: Error in argument"; }

eval set -- "${OPTS}" # evaluating to avoid white space separated expansion

while true; do
    case ${1} in
	--version|-v)
	    version
	    exit 0;;
	--kernel|-k)
	    kernel="${2}"
	    shift 2;;
	--help|-h)
	    usage
	    exit 0;;
	--)
	    shift
	    break;;
	*)
	    usage
	    exit 1;;
    esac
done; unset OPTS version error

int="${1}"

re="^[0-9]{1,2}\.[0-9]{1,2}(\.[0-9]{1,2})?$"
[[ "${kernel}" =~ ${re} ]] || { usage; exit 1; }; unset re usage

### </script_arguments>

majver="v${kernel%%.*}.x" # major version in format "vN.x" where N is an int
changelog="$(curl -f -o - -sS --compressed https://www.kernel.org/pub/linux/kernel/${majver}/ChangeLog-${kernel})"; unset majver kernel # scrape changelog from kernel.org

if [[ "${int}" =~ ^-?[0-9]+$ ]]; then
    echo "${changelog}" | awk -v n=${int} '/^commit/ {line++} (line==n) {print}' # match n from ^commit until next ^commit
else
    echo "${changelog}"
fi; unset changelog int

exit 0