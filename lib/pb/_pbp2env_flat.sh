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
# Defines function: bfl::pbp2env_flat().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Copy pbpaste to environment variable ${PBENV}.
#
# @example
#   bfl::pbp2env_flat
#------------------------------------------------------------------------------
bfl::pbp2env_flat() {
  # Verify dependencies.
  bfl::verify_dependencies 'pbpaste' || return $?

    unset PBENV
    export PBENV="$( pbpaste | tr -s "[:space:]" " " )"
    printf "%s=%q\n" PBENV "${PBENV}"
  }