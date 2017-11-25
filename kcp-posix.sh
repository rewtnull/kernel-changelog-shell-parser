#!/bin/sh

#    kernel.org changelog shell parser posix v0.6
#    Copyright (C) 2017 Marcus Hoffren.
#    License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
#    This is free software: you are free to change and redistribute it.
#    There is NO WARRANTY, to the extent permitted by law.
#
#    Written by Marcus Hoffren. marcus@harikazen.com

version() {
    printf "%s\n" "kernel.org changelog shell parser posix v0.6"
    printf "%s\n" "Copyright (C) 2017 Marcus Hoffren."
    printf "%s\n" "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    printf "%s\n" "This is free software: you are free to change and redistribute it."
    printf "%s\n" "There is NO WARRANTY, to the extent permitted by law."
    printf "%s\n" ""
    printf "%s\n" "Written by Marcus Hoffren. marcus@harikazen.com"
    printf "%s\n" ""
}

usage() {
    printf "%s\n" "Usage: ${0##*/} [-h] [-v] <-k <version>> [int|hash]"
    printf "%s\n" ""
    printf "%s\n" "-h                      Display this help"
    printf "%s\n" "-v                      Display version and exit"
    printf "%s\n" ""
    printf "%s\n" "OPTIONS"
    printf "%s\n" ""
    printf "%s\n" "-k <version>            Kernel version in format"
    printf "%s\n" "                        <1-9>[1-9].<1-9>[1-9][.<1-9>[1-9]]"
    printf "%s\n" "int                     Commit# (in order of appearance)"
    printf "%s\n" "hash                    Commit hash"
    printf "%s\n" ""
    printf "%s\n" "Required option is -k, and optionally an integer or a hash"
    printf "%s\n" ""
}

# extractver(main|maj|min) - extracts main, major, or min version from version string
extractver() {
    if [ "$1" = "main" ]; then
	echo "${kernel%%.*}"
    elif expr "$kernel" : "^[0-9]\{1,2\}\.[0-9]\{1,2\}\.[0-9]\{1,2\}$" >/dev/null; then  # is format N[N].N[N].N[N]
	[ "$1" = "maj" ] && { tmpkrn=${kernel#*.*}; echo "${tmpkrn%*.*}"; } || echo "${kernel#*.*.}" # extract x.N.x
    elif expr "$kernel" : "^[0-9]\{1,2\}\.[0-9]\{1,2\}$" >/dev/null; then # is format N[N].N[N]
	mainver=$majver; majver=$minver
	[ "$1" = "maj" ] && echo "${kernel%*.*}" || echo "${kernel#*.*}"
    fi; unset tmpkrn
}

error() {
    printf "\n%s\n%s\n" "$redfg*$off ${*}" "" 1>&2; exit 1
}

bold=$(tput bold)
redfg=$(tput setaf 1)
off=$(tput sgr 0)

### <sanity_check>

which curl >/dev/null || error "$bold curl$off is missing."
which awk >/dev/null || error "$bold awk$off is missing."

### </sanity_check>

### <script_arguments>

(! getopts "vk:h" opt) && { usage; exit 1; }

while getopts "vk:h" opt; do
     case $opt in
	v) version; exit 0;;
	h) help; exit 0;;
	k) kernel=$OPTARG;;
	*) usage; exit 1;;
     esac
done; unset opt

arg="$3" # int or hash

### </script_arguments>

### <version handling>

if ! expr "$kernel" : "^[0-9]\{1,2\}\.[0-9]\{1,2\}\.\{0,1\}[0-9]\{0,2\}$" >/dev/null; then # kernel version format check
    usage; exit 1
fi

mainver=$(extractver "main") # extract main version from version string
majver=x
minver=

### </version handling>

### <scrape changelog>

changelog="$(curl -f -o - -s --compressed https://www.kernel.org/pub/linux/kernel/v"$mainver"."$majver"/ChangeLog-"$kernel")" # scrape changelog from kernel.org

if [ "$?" = "22" ]; then # return code 22 = 404
    majver=$(extractver "min")
    changelog="$(curl -f -o - -sS --compressed https://www.kernel.org/pub/linux/kernel/v"$mainver"."$majver"/ChangeLog-"$kernel")"
fi; unset minver

### </scrape changelog>

### <output>

printf "%s\n" "URL:   https://www.kernel.org/pub/linux/kernel/v$mainver.$majver/ChangeLog-$kernel"; unset majver kernel

if [ "$mainver" -lt "3" ]; then # Since older changelogs are in a different format, just display the entire changelog
    printf "%s\n" "$changelog"
elif expr "$arg" : "^[0-9]*$" >/dev/null; then # if input argument is an integer
    echo "$changelog" | awk -P -v n="${arg}" "/^commit/ {line++} (line==n) {print}" # match n from ^commit until next ^commit
elif expr "$arg" : "^[a-zA-Z0-9]*$" >/dev/null; then # if input argument consists of numbers and/or letters
    echo "$changelog" | awk -P "/^commit[[:space:]]$arg$/ {p=1;print;next} /^commit/ && p {p=0} p" # match hash until ^commit or eof
else
    printf "%s\n" "$changelog" # if no optional input argument, show the entire changelog
fi; unset mainver changelog arg redfg bold off

### </output>

exit 0
