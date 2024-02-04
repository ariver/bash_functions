#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to Java
#
# @author  A. River
#
# @file
# Defines function: bfl::run_javaws().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Find lastest java web app file in downloads and run it.
#
# @example
#   declare tmp
#   tmp="$( find ~/Downloads/. -type f -name "*.jnlp*" -mmin -5 -print0 | xargs -0 ls -1rUd )"
#   declare -p tmp
#   bfl::run_javaws "$tmp"
#------------------------------------------------------------------------------
bfl::javaws_fromdl() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || { bfl::error "arguments count $# ≠ 1"; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify dependencies.
  bfl::verify_dependencies 'find' 'javaws' 'sed' 'xargs' || return $?

  local tmp
  tmp="$( find ~/Downloads/. -type f -name "*.jnlp*" -mmin -5 -print0 | xargs -0 ls -1rUd )"
  local -p tmp

  echo "${tmp}" |
        sed -n '$p' |
        xargs -tI@ javaws -verbose -wait "@"
  }