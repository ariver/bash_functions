#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to screen and pictures.
#
# @author  A. River
#
# @file
# Defines function: bfl::grab2clip().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Captures screen to buffer.
#
# @example
#   bfl::grab2clip
#------------------------------------------------------------------------------
bfl::grab2clip() {
  # Verify dependencies.
  bfl::verify_dependencies 'screencapture' || return $?

  printf '\n'
  screencapture -h 2>&1 | sed '1,/^ *-i /d;/^ *-m /,$d;s/^             //'
  printf '\n'

  screencapture -cio
  }