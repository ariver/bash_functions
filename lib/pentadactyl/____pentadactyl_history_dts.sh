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
# Defines function: bfl::pentadactyl_history_dts().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ................................
#
# @example
#   bfl::pentadactyl_history_dts
# shellcheck disable=SC2016
#------------------------------------------------------------------------------
bfl::___pentadactyl_history_dts() {
  # Verify dependencies.
  bfl::verify_dependencies 'paste' || return $?

  local -i iErr=0   # variables declarations
  eval "$( bfl::___pentadactyl_common_source )" || { iErr=$?; bfl::error 'eval $( bfl::___pentadactyl_common_source )'; return ${iErr}; }

  while read -r ent; do
      dts="${ent%%${tc_tab}*}"
      dts="${dts%??????}"
      date -j -f %s "+%Y-%m/%d %H:%M:%S" "${dts}" 2>/dev/null || \
          { iErr=$?; bfl::error 'eval $( bfl::___pentadactyl_common_source )'; return ${iErr}; }
      echo "${ent}"
  done | paste - -
  }