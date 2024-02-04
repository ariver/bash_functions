#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to the Secure Shell
#
# @author  A. River
#
# @file
# Defines function: bfl::ssh_debug_test().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ..............................
#
# @param String $ssh_args
#   ssh arguments. Remainder of arguments can be pretty much anything you would otherwise provide to ssh.
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::ssh_debug_test "$ssh_args"
#------------------------------------------------------------------------------
bfl::ssh_debug_test() {
  # Verify dependencies.
  bfl::verify_dependencies 'egrep' 'ssh' || return $?

  local -i iErr=0
  local s='Applying|identity|Found|key:|load_hostkeys:|Offering)|Authenticat|OKOKOK'
  ssh -vvv -oControlPath=none "${@}" echo OKOKOK 2>&1 |
        egrep --line-buffered '(debug[0-9]: (Reading|.*: '"$s"')' || { iErr=$?; bfl::writelog_fail "${FUNCNAME[0]}: Failed ssh -vvv -oControlPath=none '...' echo OKOKOK 2>&1 | egrep --line-buffered '(debug[0-9]: (Reading|.*: '$s')"; return ${iErr}; }
  }