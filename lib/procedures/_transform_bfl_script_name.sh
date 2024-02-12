#!/usr/bin/env bash
# Prevent this file from being sourced more than once (from Jarodiv)
[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] &&
  {
  _bfl_temporary_var="${BASH_SOURCE%/*}"; _bfl_temporary_var="${_bfl_temporary_var##*/}/${BASH_SOURCE##*/}";
  _bfl_temporary_var=$(echo "${_bfl_temporary_var}" | sed 's/\.sh$//' | tr [:lower:] [:upper:]);
  _bfl_temporary_var="_GUARD_BFL_${_bfl_temporary_var/\//}";
  } || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# --------- https://github.com/AlexeiKharchev/bash_functions_library ----------
#
# Library of internal library functions
#
# @author  Alexei Kharchev
#
# @file
# Defines function: bfl::transform_bfl_script_name().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Making variable to indicate about script is already loaded
#
# _die.sh => _GUARD_BFL_DIE
# So, it looks like C include files
# #ifdef _INCLUDE_H     =>  _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})"
# ...                       [[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#                           ...
# #endif
#
# This protect from sourcing functions from lib/ more than once
# and makes script's headers short
#
# @example
#   bfl::transform_bfl_script_name ${BASH_SOURCE}
#------------------------------------------------------------------------------
bfl::transform_bfl_script_name() {
  # Verify argument count.
  [[ $# -eq 1 ]] || { bfl::error "arguments count $# ≠ 1"; return ${BFL_ErrCode_Not_verified_args_count}; }

  local s="${1##*/lib/}"  # subdir/$(basename "$1")
  s="${s%.sh}"            # cut .sh from line end
  s="_guard_bfl_${s/\//}" # removes slashes
  s="${s^^}"              # upper case

  printf "%s\\n" "$s"
  }