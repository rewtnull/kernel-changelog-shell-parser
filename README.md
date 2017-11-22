NAME

	kcp - kernel.org changelog shell parser

VERSION

	0.3

SYNOPSIS:

	kcp.sh [-h|--help] [-v|--version] <-k|--kernel <version>> [int]

DESCRIPTION

	This script displays kernel changelogs from
	https://www.kernel.org/pub/linux/kernel/v*.x/ in shell.

	For unknown reasons, only minor updates (x.x.x) have a changelog on
	kernel.org. Thus even though this script supports the format, major
	(x.x) releases will return a 404. Example: At the time this script is
	written, the latest major version is 4.14, which lacks a changelog.
	However, when the minor 4.14.1 update is released there will be a
	changelog for it available.

	- By default it displays the entire changelog for the selected
	  kernel version
	- Optionally displays commit# (in order of appearance in changelog)
	  if an integer is entered at the end of the script arguments.

ARGUMENTS

	-h, --help			Display this help
	-v, --version			Display version and exit

	OPTIONS

	-k, --kernel <version>	Kernel version in format
					<1-9>[1-9].<1-9>[1-9][.<1-9>[1-9]]
	int				Commit# (in order of appearance)

	Required option is --kernel, and optionally an integer

DEPENDENCIES

	You need to be root to run this script

	- bash v4.2 or newer
	- curl
	- awk
	- getopt from util-linux

	kcp.sh has built in sanity checks and will exit if any of these
	conditions are not met.

CONFIGURATION

	None, as of now

AUTHOR

	Written by Marcus Hoffren

REPORTING BUGS

	Report kcp.sh bugs to marcus@harikazen.com
	Updates of gch.sh and other projects of mine can be found at
	https://github.com/rewtnull?tab=repositories

COPYRIGHT

	Copyright © 2017 Marcus Hoffren. License GPLv3+:
	GNU GPL version 3 or later - http://gnu.org/licenses/gpl.html

	This is free software: you are free to change and redistribute it.
	There is NO WARRANTY, to the extent permitted by law.

CHANGELOG

	LEGEND: [+] Add, [-] Remove, [*] Change, [!] Bugfix

	v0.1 (20171121)		[+] Initial release
	v0.2 (20171121)		[*] Fixed some (non breaking) typos in code and readme
					[!] Fixed some sanity check bugs based on some tips from /r/bash
					[*] Cleaned up some code and squashed a couple of shellcheck warnings
	v0.3 (20171122)		[-] Removed some unnecessary code
					[*] Now using tput instead of hardcoded terminal sequences for output
					[!] Fixed silly little bug in bash version check


TODO

	Send ideas to marcus@harikazen.com
