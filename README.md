NAME

	kcp - kernel.org changelog shell parser

VERSION

	0.7

SYNOPSIS:

	kcp.sh [-h|--help] [-v|--version] <-k|--kernel <version>> [int|hash]

DESCRIPTION

	This script displays kernel changelogs from
	https://www.kernel.org/pub/linux/kernel/v*.x/ in shell.

	bash and (fully POSIX compliant) sh versions included.

	- By default it displays the entire changelog for the selected
	  kernel version
	- If an integer is entered at the end of the script arguments,
	  it displays commit # (in order of appearance in changelog)
	- If a hash is entered at the end of the script arguments,
	  it displays a commit by hash

	Changelogs older than v3.x use a different format so any optional
	arguments will be ignored for these, and the entire changelog will
	be displayed.

ARGUMENTS

	-h, --help			Display this help
	-v, --version			Display version and exit

	OPTIONS

	-k, --kernel <version>	Kernel version in format
					<1-9>[1-9].<1-9>[1-9][.<1-9>[1-9]]
	int				Commit# (in order of appearance)
	hash				Commit hash

	Required option is --kernel, and optionally an integer or a hash

	Note: The POSIX version only supports the short options.

DEPENDENCIES

	- curl
	- awk

	Additionally, depending on the script version you will need:

	    Bash version

	    - bash v4.2 or newer
	    - getopt from util-linux

	    POSIX version

	    - sh

	kcp.sh has built in sanity checks and will exit if these
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
	v0.6 (20171125)		[-] *posix* Removed redundant getopt check
					[*] *posix* Changed sanity tests to something a bit more portable
					[*] *both* Minor code cleanup
					[+] *both* Now can display changelogs older than v3.x
					[+] *both* Now displays the url in the output
	v0.7 (20171127)		[-] Removed root dependency mention from readme
					[-] *posix* Removed redundant getopts check
					[-] *bash* Removed unused variable declaration
					[+] *both* Added kernel.org resolve check
					[+] *both* Added a check to see if tput is present
					[+] *both* Now catching any curl return codes > 0
					[!] *both* Added needed case for return code 0
					[-] *posix* Removed -P (--posix) flag from awk. Not really needed, and breaks if not (g/m)awk

TODO

	Send ideas to marcus@harikazen.com
