#!/bin/bash

#    kernel.org changelog shell parser v0.6
#    Copyright (C) 2017 Marcus Hoffren.
#    License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
#    This is free software: you are free to change and redistribute it.
#    There is NO WARRANTY, to the extent permitted by law.
#
#    Written by Marcus Hoffren. marcus@harikazen.com

version() {
    echo "kernel.org changelog shell parser v0.6"
    echo "Copyright (C) 2017 Marcus Hoffren."
    echo "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    echo "This is free software: you are free to change and redistribute it."
    echo "There is NO WARRANTY, to the extent permitted by law."
    echo ""
    echo "Written by Marcus Hoffren. marcus@harikazen.com"
    echo ""
}

usage() {
    echo "Usage: ${0##*/} [-h|--help] [-v|--version] <-k|--kernel <version>> [int|hash]"
    echo ""
    echo "-h, --help              Display this help"
    echo "-v, --version           Display version and exit"
    echo ""
    echo "OPTIONS"
    echo ""
    echo "-k, --kernel <version>  Kernel version in format"
    echo "                        <1-9>[1-9].<1-9>[1-9][.<1-9>[1-9]]"
    echo "int                     Commit# (in order of appearance)"
    echo "hash                    Commit hash"
    echo ""
    echo "Required option is --kernel, and optionally an integer or a hash"
    echo ""
}

error() {
    echo -e "\n${redfg}*${off} ${*}\n" 1>&2; exit 1
}

missing() {
    type -p "${1}" >/dev/null || error "${bold}${1}${off} is missing. install ${bold}${2}${off}"
}

bold=$(tput bold)
redfg=$(tput setaf 1)
off=$(tput sgr 0)

### <sanity_check>

if [[ ${BASH_VERSINFO[0]} -lt "4" ]] || [[ ${BASH_VERSINFO[0]} -ge "4" && ${BASH_VERSINFO[1]} -lt "2" ]]; then
    error "${0##*/} requires ${bold}bash v4.2${off} or newer"
fi

[[ $(getopt -V) =~ util-linux ]] || error "getopt is missing, or is the wrong version. ${bold}util-linux getopt${off} is required"

missing "curl" "curl"
missing "awk" "awk"

### </sanity_check>

### <script_arguments>

OPTS=$(getopt -nkcp.sh -a -o "vk:h" -l "version,kernel:,help" -- "${@}") || error "${bold}getopt${off}: Error in argument"

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
done; unset OPTS version redfg bold off

arg="${1}"

re="^[0-9]{1,2}\.[0-9]{1,2}(\.[0-9]{1,2})?$"
[[ ${kernel} =~ ${re} ]] || { usage; exit 1; }; unset re # kernel version format check

### </script_arguments>

majver=v${kernel%%.*}.x # major version in format "vN.x" where N is an int
changelog=$(curl -f -o - -sS --compressed https://www.kernel.org/pub/linux/kernel/"${majver}"/ChangeLog-"${kernel}"); unset majver kernel # scrape changelog from kernel.org

if [[ ${arg} =~ ^-?[0-9]+$ ]]; then # if input argument is an integer
    echo "${changelog}" | awk -v n="${arg}" "/^commit/ {line++} (line==n) {print}" # match n from ^commit until next ^commit
elif [[ ${arg} =~ ^[a-zA-Z0-9]+$ ]]; then # if input argument consists of numbers and/or letters
    echo "${changelog}" | awk "/^commit[[:space:]]${arg}$/ {p=1;print;next} /^commit/ && p {p=0} p" # match hash until ^commit or eof
else
    echo "${changelog}" # if no input argument, show the entire changelog
fi; unset changelog arg

exit 0
