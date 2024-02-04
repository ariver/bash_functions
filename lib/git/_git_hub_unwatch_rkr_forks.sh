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
# Defines function: bfl::git_hub_unwatch_rkr_forks().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ..............................
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::git_hub_unwatch_rkr_forks
#------------------------------------------------------------------------------
bfl::git_hub_unwatch_rkr_forks() {
  # Verify dependencies.
  bfl::verify_dependencies 'cut' 'egrep' 'paste' 'sed' 'sort' || return $?

  local {watching,arr,repo}=
  watching="$( git-hub watching | sed -n 's/^[0-9]*) //p' )"
  arr=$( echo "${watching}" |
        egrep "/$( echo "${watching}" | egrep '^(racker|rackerlabs)/' | cut -d/ -f2 | sort -u | paste -sd'|' - )\$" |
        egrep -v '^(racker|rackerlabs)/' )
  for repo in ${arr[@]}; do
        git-hub unwatch "${repo}"
  done
  }