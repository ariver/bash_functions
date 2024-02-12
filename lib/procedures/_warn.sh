#!/usr/bin/env bash
# Prevent this file from being sourced more than once (from Jarodiv)
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
# Defines function: bfl::warn().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Prints a warning message to stderr.
#
# The message provided will be prepended with "Warning. "
#
# @param String $msg (optional)
#   The message.
#
# @example
#   bfl::warn "The foo is bar."
#------------------------------------------------------------------------------
bfl::warn() {
  local writelog=false
  [[ ${BASH_LOG_LEVEL} -lt ${_BFL_LOG_LEVEL_WARN} ]] ||
      { [[ -n "$BASH_FUNCTIONS_LOG" ]] && [[ -f "$BASH_FUNCTIONS_LOG" ]] && writelog=true; }

  # Сама функция возвращает 0 - смысла нет оперировать кодом ошибки, из-за замены  exit 1 => return 1
  [[ $BASH_INTERACTIVE == true ]] || [[ $writelog == true ]] || return 0

  # Verify arguments count.
  [[ $# -eq 1 ]] || { bfl::error "arguments count $# ≠ 1."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Build a string showing the "stack" of functions that got us here.
  local stack
  stack="$(bfl::print_function_stack)"

  # Declare positional argument (readonly).
  local msg="$1"
  [[ -z "$1" ]] && msg="Unspecified warning."

  # shellcheck disable=SC2154
  if [[ $writelog == true ]]; then # writes message and stack.
      bfl::write_log_warn "Warning: ${msg}"
      bfl::write_log_warn "[${stack}]"
  fi

  [[ $BASH_INTERACTIVE == true ]] || return 0
  [[ -n "$PS1" ]] || return 0

#  Only if running interactively
  case $- in
      *i*)  # Prints message and stack.
          printf "%b\\n" "${CLR_WARN}Warning. ${msg}${NC}" 1>&2
          printf "%b\\n" "${CLR_DESCRIPT}[${stack}]${NC}" 1>&2
          ;;
      *)      # do nothing
          ;;  # non-interactive
  esac
  }