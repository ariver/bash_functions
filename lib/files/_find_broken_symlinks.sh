#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to manipulations with files
#
# @author  A. River
#
# @file
# Defines function: bfl::find_broken_symlinks().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Run broken symlinks search.
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::find_broken_symlinks
#------------------------------------------------------------------------------
bfl::find_broken_symlinks() {
  find -L "${@:-.}" -type l -exec ls -lond '{}' \;
  }