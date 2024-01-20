#!/usr/bin/env bash

#------------------------------------------------------------------------------
# ----------- https://github.com/jmooring/bash-function-library.git -----------
#
# Bash functions library loader
#
# @author  Joe Mooring
#
# @file
# Sources files adjacent to (in the same directory as) this script.
#
# This is the required directory structure:
#
# └── library (directory name and location are irrelevant)
#     ├── autoload.sh
#     ├── _file_1.sh
#     ├── _file_2.sh
#     └── _file_3.sh
#
# This script defines and then calls the autoload function.
#
# The autoload function loops through the files in the library directory, and
# sources file names that begin with an underscore.
#
# An "underscore" file should contain one and only one function. The file name
# should be equal to the function name, preceded by an underscore.
#
# So here's the scenario...
#
# You are creating a script ($HOME/foo.sh) to parse a text file. You need to
# trim (remove leading and trailing spaces) some strings. Trimming is a common
# task, a capability you are likely to need within other scripts.
#
# Instead of writing a trim function within foo.sh, write the function within
# a new file named _trim.sh in the library directory.
#
# Finally, source path/to/autoload.sh at the beginning of foo.sh. All of the
# functions in the library are now available to foo.sh.
#
# The relative path from foo.sh to autoload.sh is irrelevant.
#
# There is no need to set the executable bit on any of the files in the
# library directory. In fact, Google's "Shell Style Guide" specifically forbids
# this:
#
#   "Libraries must have a .sh extension and should not be executable."
#
# See https://google.github.io/styleguide/shell.xml#File_Extensions.
#
# Logical functions in this library, such as bfl::is_integer() or
# bfl::is_empty(), should not output any messages. They should only return 0
# if true or return 1 if false.
#
# To simplify usage, place this line at the top of $HOME/.bashrc:
#
#   export BASH_FUNCTIONS_LIBRARY="$HOME/path/to/autoloader.sh"
#
# Then, at the top of each new script add:
#
#   source "${BASH_FUNCTIONS_LIBRARY}" ||
#     { printf "Error. Unable to source BASH_FUNCTIONS_LIBRARY.\\n" 1>&2; exit 1; }
#
# shellcheck disable=SC1091
# shellcheck disable=SC2034
#------------------------------------------------------------------------------

# each script header depends on ${BASH_FUNCTIONS_LIBRARY}, so it is neccesary
[[ "${BASH_SOURCE}" = "${BASH_FUNCTIONS_LIBRARY}" ]] || return 1

# protect from reloading twice
source "${BASH_FUNCTIONS_LIBRARY%/*}"/lib/procedures/_transform_bfl_script_name.sh
_bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE##*/})"
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1

# Confirm we have BASH greater than v4
source "${BASH_SOURCE%/*}"/lib/procedures/_die.sh
source "${BASH_SOURCE%/*}"/lib/procedures/_error.sh
[[ -z "${BASH_VERSINFO+x}" ]] || [[ "${BASH_VERSINFO:-0}" -ge 4 ]] ||
  bfl::die "Error: BASH_VERSINFO is '${BASH_VERSINFO:-0}'.  This script requires BASH v4 or greater."

# some global variables
source "${BASH_SOURCE%/*}"/consts

case $- in
    *i*)   # Only if running interactively
        ;; # do nothing
    *)     # do nothing
        unset BASH_INTERACTIVE;
        readonly BASH_INTERACTIVE=false;
        ;; # non-interactive
esac

#set -uo pipefail
set +u # The only checking I can switch on
set -o functrace -o pipefail # -eE - моментальный вылет, ничего не успев записать

#------------------------------------------------------------------------------
# @function
# Sources files adjacent to (in the same directory as) this script.
#
# This will only source file names that begin with an underscore.
#------------------------------------------------------------------------------
bfl::autoload() {

  function _bfl_parse_params() {
      local param
      while [[ $# -gt 0 ]]; do
          param="$1"
          shift
          case $param in          # https://github.com/ralish/bash-script-template/script.sh
              -h | --h | --help)        cat << EOF
Usage:
     -h | --h | --help            Displays this help
     -q | --quiet                 Displays no extra output
    -nc | --nc | --no-colour      Disables colour output
    -cr | --cr | --cron           Run silently unless we encounter an error
EOF
                                        return 0 ;;
             -q  | --quiet)             declare -g BASH_INTERACTIVE=false ;;
             -nc | --nc | --no-colour)  declare -g BASH_COLOURED=false ;;
             -cr | --cr | --cron)       cron=true ;;
              *)  script_exit "Invalid parameter was provided: $param" 1 ;;
          esac
      done
  }

  local autoload_canonical_path   # Canonical path to this file.
  local autoload_directory        # Directory in which this file resides.
  autoload_canonical_path=$(readlink -e "${BASH_SOURCE[0]}") || bfl::die "readlink -e ${BASH_SOURCE[0]}"
  autoload_directory=$(dirname "${autoload_canonical_path}") || bfl::die "dirname ${autoload_canonical_path}"

  local file        # source functions
  for file in "${autoload_directory}"/lib/*/_*.sh; do
# to debug if error:
#   printf "file: $file\n" >> "$BASH_FUNCTIONS_LOG"
# shellcheck disable=SC1090
      source "${file}" || bfl::die "source '${file}'"
  done
  }

# Invoke main with args if not sourced
# Approach via: https://stackoverflow.com/a/28776166/8787985
if (return 0 2> /dev/null); then _bfl_temporary_var=true; fi
if [[ ${_bfl_temporary_var} == true ]]; then
  bfl::autoload
else
  [[ ${BASH_INTERACTIVE} == true ]] && printf "Script not being sourced\n"
  bfl::autoload "$@"
fi
  #                                                                                                 {BASH_SOURCE[*]}  $1 $2 $3 $4 $5 $6 $7 $8 $9
#  trap 'bfl::trap_cleanup "$?" "${BASH_LINENO[*]}" "$LINENO" "${FUNCNAME[*]}" "$BASH_COMMAND" "$0" "${BASH_SOURCE[0]}" "$*" "${BASH_FUNCTIONS_LOG}"' EXIT INT TERM SIGINT SIGQUIT SIGTERM ERR

# Enable xtrace if the DEBUG environment variable is set
[[ "${DEBUG,,}" =~ ^1|yes|true$ ]] && set -o xtrace    # Trace the execution of the script (debug)

# it's better to check dependencies at once, than dynamically check them every time bt bfl::verify_dependencies()
bfl::global_declare_dependencies 'sed' 'aws' 'brew' 'cat' 'ccache' 'chmod' 'compgen' 'curl' 'dpkg' 'find' \
  'getconf' 'git' 'grep' 'head' 'iconv' 'ifconfig' 'javaws' 'jq' 'ldapsearch' 'ldd' 'mkdir' 'mktemp' \
  'opensnoop' 'openssl' 'pbcopy' 'pbpaste' 'perl' 'proxychains4' 'pwgen' 'python' 'rm' 'rmdir' 'ruby' \
  'screencapture' 'sendmail' 'shuf' 'speedtest-cli' 'sqlite3' 'ssh' 'tail' 'tput' 'uname' 'vcsh'
