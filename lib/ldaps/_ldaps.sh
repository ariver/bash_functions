#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to ldaps
#
# @author  A. River
#
# @file
# Defines function: bfl::ldaps().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Runs ldapsearch - Unwrap ldif output
#
# @param String $ldaps_args
#   ldaps arguments. Remainder of arguments can be pretty much anything you would otherwise provide to ldaps.
#
# @return String $result
#   Text.
#
# @example
#   bfl::ldaps ...
#------------------------------------------------------------------------------
bfl::ldaps() {
  # Verify arguments count.
  (( $# > 0 && $# < 1000 )) || { bfl::error "arguments count $# ∉ [1..999]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify dependencies.
  bfl::verify_dependencies 'awk' 'ldapsearch' || return $?

  ldapsearch "$@" \
    | awk '(!sub(/^[[:blank:]]/,"")&&FNR!=1){printf("\n")};{printf("%s",$0)};END{printf("\n")}'
  }