#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to Git commands
#
# @author  A. River
#
# @file
# Defines function: bfl::gitC().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ..............................
#
# @example
#   bfl::gitC
#------------------------------------------------------------------------------
function gitC() { bfl::gitC "$@"; return $?; }  # for compability with Ariver' repository

bfl::gitC() {
  # Verify dependencies.
  bfl::verify_dependencies 'compgen' || return $?

  local {tmps,tmp,tc_tab}=
  local rgx='^([^[:blank:]]*).*[[:blank:]]git commit -m "([^"]*)"'
  printf -v tc_tab '\t'

  for tmp in $( compgen -c gitC ); do
      [[ "${tmp}" != gitC ]] || continue
      tmp="$( declare -f "${tmp}" )"
      [[ "${tmp}" =~ ${rgx} ]] || continue
      printf '%s\t%s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
  done
  }