#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to brew
#
# @author  A. River
#
# @file
# Defines function: bfl::brew_new().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   .............................
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::brew_new
#------------------------------------------------------------------------------
bfl::brew_new() {
  # Verify arguments count.
  (($# < 2)) || { bfl::error "arguments count $# ∉ [0..1]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify dependencies.
  bfl::verify_dependencies 'brew' || return $?

  local dts
  dts="$( date -r $(( $( date +%s ) - ${1:-7} * 24 * 60 * 60 )) +%Y-%m-%d )"
  brew log --grep='(new formula)' --since="${dts}" | sed -n 's/^[[:blank:]]*\([^[:blank:]]*\).*(new formula).*/\1/p' | sort -u
  }