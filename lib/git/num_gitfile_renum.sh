#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to Git commands
#
# @author  A. River
#
# @file
# Defines function: bfl::num_gitfile_renum().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ..............................
#
# @example
#   bfl::num_gitfile_renum 5 ....
#------------------------------------------------------------------------------
bfl::num_gitfile_renum() {
  # Verify arguments count.
  (( $# > 1 && $# < 1000 )) || { bfl::error "arguments count $# ∉ [2..999]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify dependencies.
  bfl::verify_dependencies 'git' || return $?
#  [ -n "${1}" -a "${#}" -gt 1 ] || return 1  То же самое

  # Verify argument values.
  bfl::is_integer "$1" || { bfl::error "Argument '$1' is has no integer type"; return ${BFL_ErrCode_Not_verified_arg_values}; }

  local {f,file_d,file_n,file_b,diff,files}=
  local -i {i,j,iErr}=0

  diff="${1}"; shift
  files=("${@}")

  for f in "${files[@]}"; do
      file_d="${f%/*}"
      [[ "${file_d}" == "${f}" ]] && file_d=

      file_n="${f##*/}"

      i="${file_n%%_*}"
      file_b="${file_n#*_}"

      printf -v j %02d "$(( i + diff ))"

      command git mv -k $( [[ $BASH_INTERACTIVE == true ]] && echo "-v" ) "${f}" "${file_d:+${file_d}/}${j}_${file_b}" || { iErr=$?; bfl::error "Failed command git mv -vk '$f' '${file_d:+${file_d}/}${j}_${file_b}'"; return ${iErr}; }
  done
  }