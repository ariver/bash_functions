#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to pentadactyl
#
# @author  A. River
#
# @file
# Defines function: bfl::pentadactyl_history_sets().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ................................
#
# @example
#   bfl::pentadactyl_history_sets
# shellcheck disable=SC2016
#------------------------------------------------------------------------------
bfl::pentadactyl_history_sets() {
  # Verify dependencies.
  bfl::verify_dependencies 'sed' 'sort' || return $?

  local -i iErr=0   # variables declarations
  eval "$( bfl::___pentadactyl_common_source )" || { iErr=$?; bfl::error 'eval $( bfl::___pentadactyl_common_source )'; return ${iErr}; }

  bfl::pentadactyl_history_commands |
    sed -n "s/\(${tc_tab}set[^=]*\)=\(..*\)/\1${tc_tab}\2/p" |
    sort -t"${tc_tab}" -k 1,1g |
    sed "s/\(${tc_tab}set[^${tc_tab}]*\)${tc_tab}/\1=/"
  }