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
# Defines function: bfl::brew_via_proxy().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Runs brew using proxychains4.
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::brew_via_proxy
#------------------------------------------------------------------------------
bfl::brew_via_proxy() {
  # Verify arguments count.
  #(( $# > 0 && $# < 3 )) || { bfl::error "arguments count $# ∉ [1..2]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify dependencies.
  [[ ${!_BFL_HAS_PROXYCHAINS4} -eq 1 ]] || { bfl::error "dependency 'proxychains4' not found"; return ${BFL_ErrCode_Not_verified_dependency}; }
  [[ ${!_BFL_HAS_BREW} -eq 1 ]]         || { bfl::error "dependency 'brew' not found";         return ${BFL_ErrCode_Not_verified_dependency}; }

  local -i iErr
  proxychains4 -q brew "${@}" || { iErr=$?; bfl::error "Failed 'proxychains4 -q brew '${@}'"; return ${iErr}; }
  }