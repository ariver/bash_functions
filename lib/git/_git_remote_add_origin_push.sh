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
# Defines function: bfl::git_remote_add_origin_push().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ..............................
#
# @example
#   bfl::git_remote_add_origin_push
#------------------------------------------------------------------------------

# for compability with Ariver' repository
function git_remote_add_origin_push() { bfl::git_remote_add_origin_push "$@"; return $?; }

bfl::git_remote_add_origin_push() {
  # Verify dependencies.
  bfl::verify_dependencies 'git' || return $?

  git remote add origin "${1}"
  git push -u origin master
  }