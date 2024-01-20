#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
#----------- https://github.com/natelandau/shell-scripting-templates ----------
#
# Library of internal library functions
#
# @author  Nathaniel Landau
#
# @file
# Defines function: bfl::print_function_stack().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Prints the function stack in use. Used for debugging, and error reporting.
#
# @return String $result
#   Prints [function]:[file]:[line]. Does not print functions from the alert class.
#
# @example
#   bfl::print_function_stack
#------------------------------------------------------------------------------
bfl::print_function_stack() {
  # Verify arguments count.
  [[ $# -eq 0 ]] || { bfl::error "arguments count $# ≠ 0."; return ${BFL_ErrCode_Not_verified_args_count}; }

#  local stack="${FUNCNAME[*]}"
#  stack="${stack// / <- }"

  local s
  local -a _funcStackResponse=()
  local -a _funcStackScript=()

  local -i i=0
  local -i k=${#BASH_SOURCE[@]}
  for ((i = 1; i < k; i++)); do
      s="${BASH_SOURCE[$i]}"
#      _funcStackResponse+=("${FUNCNAME[$i]}:${s##*/}:${BASH_LINENO[$i-1]}")   # $(basename "${BASH_SOURCE[$i]}")
      _funcStackResponse+=("${FUNCNAME[$i]}")
      _funcStackScript+=("${s##*/}:${BASH_LINENO[$i-1]}")
  done

  printf "( %s" "${_funcStackResponse[0]}"
  printf ' <= %s' "${_funcStackResponse[@]:1}"
  printf ' )\n'
  printf "( %s" "${_funcStackScript[0]}"
  printf ' < %s' "${_funcStackScript[@]:1}"
  printf ' )\n'

  return 0
  }