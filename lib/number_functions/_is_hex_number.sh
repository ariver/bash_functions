#!/usr/bin/env bash

[[ -z $(echo "$BASH_SOURCE" | sed -n '/bash_functions_library/p') ]] && return 0 || _bfl_temporary_var=$(echo "$BASH_SOURCE" | sed 's|^.*/lib/\([^/]*\)/\([^/]*\)\.sh$|_GUARD_BFL_\1\2|')
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly $_bfl_temporary_var=1
#------------------------------------------------------------------------------
# ------------ https://github.com/Jarodiv/bash-function-libraries -------------
#
# Library of functions related to Bash Strings
#
# @author  Michael Strache
#
# @file
# Defines function: bfl::is_hex_number().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Determines if the argument is a hexadecimal number.
#
# @param string $value_to_test
#   The value to be tested.
#
# @return boolean $result
#        0 / 1 (true/false)
#
# @example
#   bfl::is_hex_number "DFFFF8"
#------------------------------------------------------------------------------
#
bfl::is_hex_number() {
  bfl::verify_arg_count "$#" 1 1 || exit 1  # Verify argument count.

#                 ${regex}
  ! [[ "$1" =~ ^[0-9a-fA-F]+$ ]] && return 1
  }
