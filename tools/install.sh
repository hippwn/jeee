JEEE_HOME="~/.jeee"

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

	log_info() {
		printf "${BLUE}${BOLD}[-]${NORMAL} $1\n"
	}

	log_warn() {
		printf "${YELLOW}${BOLD}[+]${NORMAL} $1\n"
	}

	check_if_installed() {
		if ! command -v $1 >/dev/null 2>&1; then
			log_warn "${BOLD}$1${NORMAL} is not installed! Please install it first."
			quit_install
		else
			log_info "${BOLD}$1${NORMAL} is installed!\n"
		fi
	}

	quit_install() {
		printf "${RED}[!]${NORMAL} Critical error... aborting!\n"
		exit 1
	}

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
	git clone --depth=1 https://github.com/hippwn/jeee.git "$JEEE_HOME" || {
		log_warn "git clone of oh-my-zsh repo failed."
		quit_install
	}

	# Adding to path
	mkdir -p $JEEE_HOME/bin
	echo ". $JEEE_HOME/tools/rc.sh"

	printf "${GREEN}"
	echo '        __              '
	echo '       / /__  ___  ___  '
	echo '  __  / / _ \/ _ \/ _ \ '
	echo ' / /_/ /  __/  __/  __/ '
	echo ' \____/\___/\___/\___/  '
	echo ''
	echo ''
	echo 'Please reload your shell config file: . ~/.bashrc'
	printf "${NORMAL}\n"

}

main