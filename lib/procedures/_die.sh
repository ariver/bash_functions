#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
#
# Library of internal library functions
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::die().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Prints a fatal error message to stderr, then exits with status code 1.
#
# The message provided will be prepended with "Fatal error. "
#
# @param String $msg (optional)
#   The message.
#
# @example
#   bfl::error "The foo is bar."
#
# shellcheck disable=SC2154
#------------------------------------------------------------------------------
bfl::die() {
  local -i iErr=${2:-1}

  local writelog=false
  [[ ${BASH_LOGLEVEL} -lt ${_BFL_LOG_LEVEL_ERROR} ]] ||
      { [[ -n "$BASH_FUNCTIONS_LOG" ]] && [[ -f "$BASH_FUNCTIONS_LOG" ]] && writelog=true; }

  [[ $BASH_INTERACTIVE == true ]] || [[ $writelog == true ]] || exit $iErr


  # Build a string showing the "stack" of functions that got us here.
  local stack
  stack="$(bfl::print_function_stack)"

  # Declare positional argument (readonly).
  local msg="$1"
  [[ -z "$1" ]] && msg="Unspecified error."

  # shellcheck disable=SC2154
  if [[ $writelog == true ]]; then # Print the stack.
      printf "%b\\n" "${bfl_aes_red}Error. ${msg}${bfl_aes_reset}" >> "${BASH_FUNCTIONS_LOG}"
      printf "%b\\n" "${bfl_aes_yellow}[${stack}]${bfl_aes_reset}" >> "${BASH_FUNCTIONS_LOG}"
  fi

  # Print the message.
  if [[ $BASH_INTERACTIVE == true ]]; then # Print the stack.
      printf "%b\\n" "${bfl_aes_red}Error. ${msg}${bfl_aes_reset}" 1>&2
      printf "%b\\n" "${bfl_aes_yellow}[${stack}]${bfl_aes_reset}" 1>&2
  fi

  exit $iErr
  }