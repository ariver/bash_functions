#!/usr/bin/env bash

[[ -z $(echo "$BASH_SOURCE" | sed -n '/bash-function-library/p') ]] && return 0 || _bfl_temporary_var=$(echo "$BASH_SOURCE" | sed 's|^.*/lib/\([^/]*\)/\([^/]*\)\.sh$|_GUARD_BFL_\1\2|')
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly $_bfl_temporary_var=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
# @file
# Defines function: bfl::string_replace().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Replace substring in string
#
# Bash StrReplace analog
#
# @param string $main_string
#   String where replacement executes
#
# @param string $search_string
#   String to remove
#
# @param string $new_string
#   String to paste
#
# @example
#   bfl::string_replace "/home/alexei/.local/lib/site-packages" "/home/alexei/.local" "/usr"
#------------------------------------------------------------------------------
bfl::string_replace() {
  bfl::verify_arg_count "$#" 3 3 || exit 1  # Verify argument count.

  local srch=$1; #local substr=$2; local rplce=$3
  local str st2
  str=`echo "$2" | sed 's|/|\\\/|g'`      # echo $substr
  st2=`echo "$srch" | sed -n "/$str/p"`
  while [[ -n "$st2" ]]; do
      srch=`echo "$srch" | sed "s|$str|$3|g"`   # s|$str|$rplce|g
      st2=`echo "$srch" | sed -n "/$str/p"`
  done

  echo "$srch"
  return 0
  }