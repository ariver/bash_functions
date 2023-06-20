#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ /bash_functions_library ]] && _bfl_temporary_var=$(echo "$BASH_SOURCE" | sed 's|^.*/lib/\([^/]*\)/\([^/]*\)\.sh$|_GUARD_BFL_\1\2|') || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly $_bfl_temporary_var=1
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
#
# Library of functions related to Linux Systems
#
#
#
# @file
# Defines function: bfl::get_perl_prefix().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Gets directory path of perl
#
# @return string $perl_prefix
#   The Perl library prefix.
#
# @example
#   bfl::get_perl_prefix
#------------------------------------------------------------------------------
bfl::get_perl_prefix() {
  bfl::verify_arg_count "$#" 0 0 || { bfl::writelog_fail "${FUNCNAME[0]} arguments count $# ≠ 0"; return $BFL_ErrCode_Not_verified_args_count; } # Verify argument count.

  local str=$(dirname $(which perl))
  [[ (! -n $str) || ($str == $'/') ]] && str='' || str=$(dirname "$str")
  echo "$str"
  return 0
  }
