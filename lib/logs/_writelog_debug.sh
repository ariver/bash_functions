#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ /bash_functions_library ]] && _bfl_temporary_var=$(echo "$BASH_SOURCE" | sed 's|^.*/lib/\([^/]*\)/\([^/]*\)\.sh$|_GUARD_BFL_\1\2|') || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly $_bfl_temporary_var=1
#------------------------------------------------------------------------------
# ------------ https://github.com/Jarodiv/bash-function-libraries -------------
#
# Library of functions related to terminal and file logging
#
# @author  Michael Strache
#
# @file
# Defines function: bfl::writelog_debug().
#------------------------------------------------------------------------------

# **************************************************************************** #
# Dependencies                                                                 #
# **************************************************************************** #
source "$(dirname $BASH_FUNCTION_LIBRARY)"/lib/logs/_write_log.sh

#------------------------------------------------------------------------------
# @function
# Prints passed Message on Log-Level debug to stdout.
#
# @param string $MESSAGE
#   Message to log.
#
# @param String $STATUS
#   Short status string, that will be displayed right aligned in the log line.
#
# @param String    LogFile (optional)
#   Log file.
#
# @example
#   bfl::writelog_debug "Some string ...."
#------------------------------------------------------------------------------
#
bfl::writelog_debug() {
  bfl::verify_arg_count "$#" 1 3 || { # Нельзя bfl::die Verify argument count.
      [[ $BASH_INTERACTIVE == true ]] && printf "${FUNCNAME[0]}: error $*\n" > /dev/tty
      return 1
      }

  # Verify arguments
  bfl::is_blank "$1" && { # Нельзя bfl::die
      [[ $BASH_INTERACTIVE == true ]] && printf "${FUNCNAME[0]}: parameter 1 is blank!\n" > /dev/tty
      return 1
      }

  local -r msg="$1"
  local -r logfile="${3:-$BASH_FUNCTION_LOG}"
  bfl::write_log $LOG_LVL_DEBUG "$msg" "${2:-Debug}" "$logfile" || {
      [[ $BASH_INTERACTIVE == true ]] && printf "${FUNCNAME[0]}: error $*\n" > /dev/tty
      return 1
      }

  [[ $BASH_INTERACTIVE == true ]] || return 0
  [[ -n "$PS1" ]] || return 0
  case $- in
      *i*) #  Only if running interactively
#                           msg
#  bfl::write_log $LOG_LVL_ERROR "$1" "${CLR_BRACKET}[${CLR_DEBUG} fail ${CLR_BRACKET}]${CLR_NORMAL}" && return 0 || return 1
  printf "${CLR_DEBUG}$msg${NC}\n" > /dev/tty
  printf "${CLR_WARN}Written log message to $logfile${NC}\n" > /dev/tty
          ;;
      *)      # do nothing
          ;;  # non-interactive
  esac

  return 0
  }
