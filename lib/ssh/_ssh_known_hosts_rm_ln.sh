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
# Defines function: bfl::ssh_known_hosts_rm_ln().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ..............................
#
# @param String $ssh_known_hosts
#   ssh known hosts file. Default "$HOME"/.ssh/known_hosts
#
# @param String $ssh_args
#   ssh arguments. Remainder of arguments can be pretty much anything you would otherwise provide to ssh.
#
# @return Boolan $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::ssh_known_hosts_rm_ln "$HOME"/.ssh/known_hosts "$ssh_args"
#------------------------------------------------------------------------------
bfl::ssh_known_hosts_rm_ln() {
  # Verify arguments count.
  (( $# > 1 && $# < 1000 )) || { bfl::error "arguments count $# ∉ [2..999]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  bfl::is_blank "$1" && { bfl::error "path is required."; return ${BFL_ErrCode_Not_verified_arg_values}; }
  [[ -f "$1" ]] || { bfl::error "file '$1' doesn't exist!"; return ${BFL_ErrCode_Not_verified_arg_values}; }

  # Verify dependencies.
  bfl::verify_dependencies 'sed' 'ssh' || return $?

  local f="${1:-"$HOME"/.ssh/known_hosts}"; shift

  local line
  for line in "${@}"; do
      printf "${FUNCNAME[0]}: Removing line [ %s ]\n" "${line}"
      sed -i~ "${line}d" "$f"
  done
  }