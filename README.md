NAME

	kcp - kernel.org changelog shell parser

VERSION

	0.5

SYNOPSIS:

	kcp.sh [-h|--help] [-v|--version] <-k|--kernel <version>> [int|hash]

DESCRIPTION

	This script displays kernel changelogs from
	https://www.kernel.org/pub/linux/kernel/v*.x/ in shell.

	bash and (fully POSIX compatible) sh versions available.

	- By default it displays the entire changelog for the selected
	  kernel version
	- If an integer is entered at the end of the script arguments,
	  it displays commit # (in order of appearance in changelog)
	- If a hash is entered at the end of the script arguments,
	  it displays a commit by hash

	For unknown reasons, only minor updates (x.x.x) have a changelog on
	kernel.org. Thus even though this script supports the format, major
	(x.x) releases will return a 404. Example: At the time this script is
	written, the latest major version is 4.14, which lacks a changelog.
	However, the minor update 4.14.1 has a changelog available.

ARGUMENTS

	-h, --help			Display this help
	-v, --version			Display version and exit

	OPTIONS

	-k, --kernel <version>	Kernel version in format
					<1-9>[1-9].<1-9>[1-9][.<1-9>[1-9]]
	int				Commit# (in order of appearance)
	hash				Commit hash

	Required option is --kernel, and optionally an integer or a hash

	Note: The POSIX compatible version only supports the short options.

DEPENDENCIES

	You need to be root to run this script

	- curl
	- awk

	Additionally, depending on the script version you will need:

	    Bash version

	    - bash v4.2 or newer for the ordinary version
	    - getopt from util-linux

	    POSIX compatible version

	    - sh

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
	v0.4 (20171122)		[+] Added support to display commit by hash
	v0.5 (20171122)		[+] Wrote and included a fully POSIX compatible version of the script
					[*] Squashed the last shellcheck warning

TODO

	Send ideas to marcus@harikazen.com
