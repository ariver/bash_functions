#! /dev/null/bash

[[ "$BASH_SOURCE" =~ /bash_functions_library ]] && _bfl_temporary_var=$(echo "$BASH_SOURCE" | sed 's|^.*/lib/\([^/]*\)/\([^/]*\)\.sh$|_GUARD_BFL_\1\2|') || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly $_bfl_temporary_var=1
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
#
# Library of functions related to the Debian
#
#
#
# @file
# Defines function: bfl::is_debian_pkg_installed().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Simple function to check if a given debian package is installed.
#
# @param String $PKG_NAME
#   Debian package name.
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::is_debian_pkg_installed "gcc1"
#------------------------------------------------------------------------------
bfl::is_debian_pkg_installed() {
  bfl::verify_arg_count "$#" 1 1  || { bfl::writelog_fail "${FUNCNAME[0]} arguments count $# ≠ 1"    ; return ${BFL_ErrCode_Not_verified_args_count}; } # Verify argument count.
  bfl::verify_dependencies "dpkg" || { bfl::writelog_fail "${FUNCNAME[0]}: dependency gpkg not found"; return ${BFL_ErrCode_Not_verified_dependency}; } # Verify dependencies.

  local str
  str=$(dpkg --status "$1" 2>/dev/null | sed -n '/^Status:/p')
  [[ "$str" == 'Status: install ok installed' ]] && return 0

  return 1
  }