#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to speedtest
#
# @author  A. River
#
# @file
# Defines function: bfl::speedtest_cli_via_en1().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ..............................
#
# @return String $result
#   ..............................
#
# @example
#   bfl::speedtest_cli_via_en1 ...
#------------------------------------------------------------------------------
bfl::speedtest_cli_via_en1() {
  # Verify arguments count.
  (( $# > 0 && $# < 1000 )) || { bfl::error "arguments count $# ∉ [1..999]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify dependencies.
  bfl::verify_dependencies 'ifconfig' 'speedtest-cli' || return $?

  local en1_ip
  en1_ip="$( ifconfig en1 )" || { bfl::writelog_fail "Failed 'ifconfig en1'"; return 1; }
  [[ "${en1_ip}" =~ .*[[:blank:]]inet[[:blank:]]+([0-9\.]*).* ]] || { bfl::error "No IP for EN1"; return 1; }

  en1_ip="${BASH_REMATCH[1]}"
  speedtest-cli ${en1_ip:+--source ${en1_ip}} "${@}"
  }