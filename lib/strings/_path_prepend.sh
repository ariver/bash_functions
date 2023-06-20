#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ /bash_functions_library ]] && _bfl_temporary_var=$(echo "$BASH_SOURCE" | sed 's|^.*/lib/\([^/]*\)/\([^/]*\)\.sh$|_GUARD_BFL_\1\2|') || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly $_bfl_temporary_var=1
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
#
# Library of functions related to Bash Strings
#
#
#
# @file
# Defines function: bfl::path_prepend().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Searches path in the variable like PATH. If not found, add directory path to the beginning of string
# This help to exclude duplicates
#
# Standart Linux path functions. The string ONLY single line
#
# @option String  -c, -x
#   -c Check directories, don't add to PATH (or other variable) if doesn't exist.
#   -x Fail if directories are not found.
#
# @param string $directory
#   The directory to be searching and prepend. There may be several paths, eg.  /opt/lib:/usr/local/lib:/home/usr/.local/lib
#
# @param string $path_variable (optional)
#   The variable to be changed. By default, PATH
#
# @example
#   bfl::path_prepend '/opt/lib:/usr/local/lib:/home/usr/.local/lib' LD_LIBRARY_PATH
#------------------------------------------------------------------------------
bfl::path_prepend() {
  bfl::verify_arg_count "$#" 1 3 || { bfl::writelog_fail "${FUNCNAME[0]} arguments count $# ∉ [1, 3]"; return $BFL_ErrCode_Not_verified_args_count; } # Verify argument count.

  local opt
  local OPTIND=1
  local _checkPaths=false
  local _failIfNotFound=false

  while getopts ":xX" opt; do
      case ${opt} in
          c | C)  _checkPaths=true ;;
          x | X)  _failIfNotFound=true ;;
          *)      bfl::writelog_fail "Unrecognized option '${1}'" "${LINENO}"
                  return 1 ;;
      esac
  done
  shift $((OPTIND - 1))

  bfl::verify_arg_count "$#" 1 2 || { bfl::writelog_fail "${FUNCNAME[0]} arguments count $# ∉ [1, 2]"; return $BFL_ErrCode_Not_verified_args_count; } # Verify argument count.

  # Verify argument values.
  bfl::is_blank "$1" && { bfl::writelog_fail "${FUNCNAME[0]}: path is empty!"; return $BFL_ErrCode_Not_verified_arg_values; }

  local -r PATHVARIABLE="${2:-PATH}"
  local str="${!PATHVARIABLE}"  # Var value by its name

  local s
  s=$(echo "$1" | sed 's/^[ :]*\(.*\)[ :]*$/\1/' | sed 's/::*/:/g')

  # PATHVARIABLE is not defined yet
  bfl::is_blank "$str" && { export $PATHVARIABLE="$s"; return 0; }

  str=$(echo "$str" | sed 's/^[ :]*\(.*\)[ :]*$/\1/' | sed 's/::*/:/g')
  [[ "$str" == "$s" ]] && return 0  # Nothing to do

  # ---------------------------------------------------------------
  local d   # If 1st parameter is one path only
  [[ "$s" =~ : ]] || { [[ ":$str:" =~ :"$s": ]]; return 0; }  # Nothing to do

  local -a arr
  if ${_failIfNotFound} || ${_checkPaths}; then
      arr=( ${s//:/ } )
      local s2=":$s:"
      for d in ${arr[@]}; do
          if ! [[ -d "$d" ]]; then
              ${_failIfNotFound} && { bfl::writelog_fail "${FUNCNAME[0]}: '$d' doesn't exist!"; return 1; }
              ${_checkPaths} && s2=$(echo "${s2}" | sed "s|:$d:|:|g")
          fi
      done
  [[ "$s2" == ':' ]] && s2=''
  [[ -n "$s2" ]] && s="${s2:1:-1}"
  fi

  # If 1st parameter is set of paths with : delimeter
  arr=(); arr=( $(echo "$str" | sed 's/:/ /g' ) )
  s=":$s:"  # Check every element of PATHVARIABLE to be contained in first parameter
  for d in ${arr[@]}; do
      s=$(echo "$s" | sed "s|:$d:|:|g")
  done

  [[ "$s" == ':' ]] && s=''
  [[ -n "$s" ]] && s="${s:1:-1}"
  [[ -n "$s" ]] && export $PATHVARIABLE="$s:$str"

  return 0
  }
