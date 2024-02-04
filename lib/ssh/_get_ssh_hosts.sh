#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to the Secure Shell
#
# @author  A. River
#
# @file
# Defines function: bfl::get_ssh_hosts().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Prints ssh hosts list.
#
# @param String $ssh_known_hosts (optional)
#   ssh known hosts file. Default "$HOME"/.ssh/known_hosts
#
# @return String $result
#   ssh known hosts list
#
# @example
#   bfl::get_ssh_hosts
#------------------------------------------------------------------------------
bfl::ssh_hosts() { bfl::get_ssh_hosts "$@"; return $?; }  # for compability with Ariver' repository

bfl::get_ssh_hosts() {
  # Verify arguments count.
  (( $# < 2 )) || { bfl::error "arguments count $# ∉ [0..1]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify argument values.
  [[ $# -eq 1 ]] && bfl::is_blank "$1" && { bfl::error "Argument 1 is blank!"; return ${BFL_ErrCode_Not_verified_arg_values}; }

  # Verify dependencies.
  bfl::verify_dependencies 'cut' 'egrep' || return $?

  local -i iErr=0
  local f="${1:-"$HOME"/.ssh/known_hosts}"
  cut -d, -f1 < ~/.ssh/known_hosts | cut -d' ' -f1 | egrep "${@}" || { iErr=$?; bfl::error "Failed cut -d, -f1 < '$f' | cut -d' ' -f1 | egrep '${@}'"; return ${iErr}; }
  }