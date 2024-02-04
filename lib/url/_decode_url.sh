#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
# ------------------- https://gist.github.com/cdown/1163649 -------------------
# ---------- https://github.com/natelandau/shell-scripting-templates ----------
#
# Library of functions related to the internet
#
# @author  Nathaniel Landau, A. River
#
# @file
# Defines function: bfl::decode_url().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Decodes a URL decoded string.
#
# @param String $str
#   The string to be decoded.
#
# @return String $rslt
#   The decoded string.
#
# @example
#   bfl::decode_url "foo bar"
#------------------------------------------------------------------------------
bfl::urldec() { bfl::decode_url "$@"; return $?; }  # for compability with Ariver' repository

bfl::decode_url() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || { bfl::error "arguments count $# ≠ 1"; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify argument values.
  bfl::is_blank "$1" && { bfl::error "Argument 1 is blank!"; return ${BFL_ErrCode_Not_verified_arg_values}; }

  local url_decoded="${1//+/ }"
  printf '%b' "${url_decoded//%/\\x}"

# ----------------- https://github.com/ariver/bash_functions ------------------
 # local {ent,enc}=
 # for ent in "${@}"; do
 #       enc="$( echo "${ent}" | sed "y/+/ /;s/%25/%/g;s/%\([0-9A-F][0-9A-F]\)/\\\\\x\1/g" )"
 #       printf "${enc}"
 # done
  }