#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
#----------- https://github.com/natelandau/shell-scripting-templates ----------
#
# Library of functions related to manipulations with files
#
# @author  A. River
#
# @file
# Defines function: bfl::pwd_env().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Transform tilde in path to ${HOME}.
#
# @param String $args (optional)
#   Directory / directories list to transform. (Default is current directory)
#
# @return String $result
#   Transformed directories list.
#
# @example
#   bfl::pwd_env /path
#------------------------------------------------------------------------------
bfl::pwdenv() {
  # Verify arguments count.
  (( $# < 2 )) || { bfl::error "arguments count $# ∉ [0..1]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  local {paths,curpath,newpath,tc_tilde}=
  printf -v tc_tilde '~'
  paths=( "${@:-${PWD}}" )

  for curpath in "${paths[@]}"; do
      [[ "${curpath}" =~ ^(${HOME}|${tc_tilde})(/.*)?$ ]] && newpath="\${HOME}${BASH_REMATCH[2]}"
      printf '%s\n' "${newpath}"
  done
  }