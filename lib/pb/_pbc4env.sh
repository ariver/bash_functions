#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to pb
#
# @author  A. River
#
# @file
# Defines function: bfl::pbc4env().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Runs pbcopy of ${PBENV}
#
# @example
#   bfl::pbc4env
#------------------------------------------------------------------------------
bfl::pbc4env() {
  # Verify dependencies.
  bfl::verify_dependencies 'pbcopy' || return $?

  printf %s "${PBENV}" | pbcopy
  }