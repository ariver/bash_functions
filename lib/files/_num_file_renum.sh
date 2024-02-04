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
# Defines function: bfl::num_file_renum().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ..............................
#
# @option String  'v'
#   Input 'v' to show verbose output.
#
# @param String $diff
#   ..............................
#
# @param String $args
#   arguments
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::num_file_renum "file.zip"
#------------------------------------------------------------------------------
bfl::num_file_renum() {
  # Verify arguments count.
  (( $# > 0 && $# < 1000 )) || { bfl::error "arguments count $# ∉ [1..999]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify argument values.
  bfl::is_blank "$1" && { bfl::error "Argument 1 is blank."; return ${BFL_ErrCode_Not_verified_arg_values}; }
#   То же самое
#  [ -n "${1}" -a "${#}" -gt 1 ] || { bfl::writelog_fail "${FUNCNAME[0]} arguments count $# ∉ [2, 999]"; return 1; } # Verify argument count.

  local {f,d,file_n,file_b,i,J}=

  local _diff="$1"; shift
  local -a files=("${@}")

  for f in "${files[@]}"; do
      d="${f%/*}"
      [[ "${d}" == "${f}" ]] && d=

      file_n="${f##*/}"

      i="${file_n%%_*}"
      file_b="${file_n#*_}"

      printf -v J %02d "$(( i + _diff ))"

      command mv -i $( [[ $BASH_INTERACTIVE == true ]] && echo "-v" ) "${f}" "${d:+${d}/}${J}_${file_b}" || \
          { iErr=$?; bfl::error "Failed command mv -i '$f' '${d:+$d/}$J_${file_b}'"; return ${iErr}; }
  done
  }