#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
#----------- https://github.com/natelandau/shell-scripting-templates ----------
#
# Library of functions related to manipulations with files
#
# @author  A. River
#
# @file
# Defines function: bfl::json_tidy().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Reads input ?
#
# @param String $path (optional)
#   Directory to search broken symlinks. (Default current directory)
#
# @return String $result
#   Files list.
#
# @example
#   bfl::json_tidy /path
#------------------------------------------------------------------------------
bfl::jsontidy() {
  # Verify arguments count.
  (( $# < 2 )) || { bfl::error "arguments count $# ∉ [0..1]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify dependencies.
  bfl::verify_dependencies 'python' || return $?

  python -c "import sys;import json;print(json.dumps(json.loads(sys.stdin.read()), ensure_ascii=1, sort_keys=1, indent=2, separators=(',',': ')));sys.exit(0)"
#  python -c "import sys,json;print json.dumps(json.loads(sys.stdin.read()),ensure_ascii=1,sort_keys=1,indent=2,separators=(',',': '));sys.exit(0)";
  }