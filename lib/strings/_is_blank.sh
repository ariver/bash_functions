#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
#
# Library of functions related to Bash Strings
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::is_blank().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Checks if a string is whitespace, empty (""), or null.
#
# Backslash escape sequences are interpreted prior to evaluation. Whitespace
# characters include space, horizontal tab (\t), new line (\n), vertical
# tab (\v), form feed (\f), and carriage return (\r).
#
# @param String $str
#   The string to check.
#
# @example
#   bfl::is_blank "foo"
#------------------------------------------------------------------------------
bfl::is_blank() {
  # Verify argument count.
  [[ $# -eq 1 ]] || { bfl::error "arguments count $# ≠ 1"; return ${BFL_ErrCode_Not_verified_args_count}; }

  [[ -z "$1" ]] || [[ "$(printf "%b" "$1")" =~ ^[[:space:]]*$ ]] # || return 1
  }
