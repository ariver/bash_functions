#!/usr/bin/env bash

# ------------ https://github.com/Jarodiv/bash-function-libraries -------------
#
# Library of functions related to terminal and file logging
#
# @author  Michael Strache
#
# @file
# Defines function: bfl::writelog_warn().
#------------------------------------------------------------------------------

# **************************************************************************** #
# Dependencies                                                                 #
# **************************************************************************** #
if ! [[ ${_GUARD_BFL_LOG:-} -eq 1 ]]; then
  declare -r BFL_WRITELOG_FILEPATH="$(dirname $BASH_FUNCTION_LIBRARY)"/lib/log_functions/_write_log.sh
  source "$BFL_WRITELOG_FILEPATH"
fi

#------------------------------------------------------------------------------
# @function
# Prints passed Message on Log-Level warning to stdout.
#
# @param string $MESSAGE
#   Message to log.
#
# @example
#   bfl::writelog_warn "some string"
#------------------------------------------------------------------------------
#
bfl::writelog_warn() {
  bfl::verify_arg_count "$#" 1 1 || exit 1

  local -r MESSAGE="${1:-}"; shift
  bfl::write_log ${LOG_LVL_WRN} "${CLR_WARN}WARNING:${CLR_NORMAL} ${MESSAGE}"
}
