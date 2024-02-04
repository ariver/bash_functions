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
# Defines function: bfl::git_display_ignored().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ..............................
#
# @example
#   bfl::git_display_ignored
#------------------------------------------------------------------------------
function git_display_ignored() { bfl::git_display_ignored "$@"; return $?; }  # for compability with Ariver' repository

bfl::git_display_ignored() {
  # Verify dependencies.
  bfl::verify_dependencies 'cat' 'column' 'git' 'sed' || return $?

  local tc_tab
  printf -v tc_tab '\t'
  git ls-files --others | git check-ignore --verbose --stdin |
      sed "s/:/${tc_tab}/;s/:/${tc_tab}/" |
      { [[ -t 1 ]] && column -ts"${tc_tab}" || cat -; }
  }