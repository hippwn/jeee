# install.sh -- install jeee environment
# MIT License
# Copyright (c) 2019 Hippolyte <hippwn>

# 
# Function definitions
# 

log_info() { printf "${BLUE}${BOLD}[-]${NORMAL} $1\n"; }

log_warn() { printf "${YELLOW}${BOLD}[+]${NORMAL} $1\n"; }

log_erro() { printf "${RED}${BOLD}[!]${NORMAL} $1\n"; }

log_succ() { printf "${GREEN}${BOLD}[*]${NORMAL} $1\n"; }

get_rc_file() {
	case "$SHELL" in
    zsh | /usr/bin/zsh ) echo ".zshrc"; break ;;
	bash | /usr/bin/bash ) echo ".bashrc"; break ;;
	ksh | /usr/bin/ksh ) echo ".kshrc"; break ;;
	fish | /usr/bin/fish ) echo ".fishrc"; break ;;
	esac
}


#
# Global variables
#

JEEE_HOME="$HOME/.jeee"
USR_RC="$HOME/$(get_rc_file)"
SRC_CMD=". $JEEE_HOME/tools/rc.sh"


#
# Variable-dependant function definition
#

uninstall() {
	# Delete JEEE_HOME if created
	if [ -d "$JEEE_HOME" ]; then rm -rf "$JEEE_HOME"; fi
	# Delete .*rc entry if created
	if [ -f $USR_RC ]; then sed -i "/$(echo ". $JEEE_HOME/tools/rc.sh" | sed -e 's/[\/&]/\\&/g')/d" $USR_RC; fi
	# Delete $PATH entry if created -- see https://unix.stackexchange.com/a/291611
	local bin="$JEEE_HOME/bin"
	PATH=${PATH//":$bin:"/":"} # delete any instances in the middle
	PATH=${PATH/#"$bin:"/} # delete any instance at the beginning
	PATH=${PATH/%":$bin"/} # delete any instance in the at the end
}

quit_error() {
	log_erro "Critical error... aborting!"
	uninstall
	exit 1
}

check_if_installed() {
	if ! command -v $1 >/dev/null 2>&1; then
		log_warn "\t${BOLD}$1${NORMAL} is not installed! Please install it first."
		quit_install
	else
		log_info "\t${BOLD}$1${NORMAL} is installed!"
	fi
}


#
# Install 
#

main() {
	# Use colors only if available
	if which tput >/dev/null 2>&1; then
		ncolors=$(tput colors)
	fi
	if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
		NORMAL=`tput sgr0`
		RED=`tput setaf 1`
		GREEN=`tput setaf 2`
		YELLOW=`tput setaf 3`
		BLUE=`tput setaf 4`
		BOLD=`tput bold`
		DIM=`tput dim`
	else
		NORMAL=""
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
		BOLD=""
		DIM=""
	fi

	# Set "exit on error" after color test
	set -o errexit


	# Check existing installation
	if [ -d "$JEEE_HOME" ]; then
		log_warn "An existing installation has been found at ${BOLD}$JEEE_HOME${NORMAL}."
		log_warn "Please save your data and run ${BOLD}jeee --uninstall${NORMAL} before retrying."
		log_warn "Quiting."
		exit
	fi

	# Check for requirements
	log_info "Checking requirements..."
	check_if_installed "docker"
	check_if_installed "docker-compose"
	check_if_installed "git"

	# Prevent the cloned repository from having insecure permissions. Failing to do
	# so causes compinit() calls to fail with "command not found: compdef" errors
	# for users with insecure umasks (e.g., "002", allowing group writability). Note
	# that this will be ignored under Cygwin by default, as Windows ACLs take
	# precedence over umasks except for filesystems mounted with option "noacl".
	umask g-w,o-w

	# Cloning repository
	log_info "Cloning repository..."
	git clone --depth=1 https://github.com/hippwn/jeee.git "$JEEE_HOME" >/dev/null 2>&1 || {
		log_warn "git clone of jeee's repository failed."
		quit_install
	}

	# Adding to path
	log_info "Adding jeee configuration to ${BOLD}$(basename $USR_RC)${NORMAL}..."
	mkdir -p $JEEE_HOME/bin
	chmod +x $JEEE_HOME/tools/jeee
	ln -s $JEEE_HOME/tools/jeee $JEEE_HOME/bin
	# Add only to .*rc if it's not already
	grep -Fxq "$SRC_CMD" $USR_RC || echo "$SRC_CMD" >> $USR_RC

	log_succ "Installation succesful!"
	
	printf "${GREEN}\n"
	echo '        __              '
	echo '       / /__  ___  ___  '
	echo '  __  / / _ \/ _ \/ _ \ '
	echo ' / /_/ /  __/  __/  __/ '
	echo ' \____/\___/\___/\___/  '
	echo "${NORMAL}"
	echo 'Please reload your shell config file by running:'
	printf "\t${BOLD}. $USR_RC"
	printf "${NORMAL}\n"
}

main
