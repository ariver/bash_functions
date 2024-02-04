#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
# ------------- https://github.com/jmooring/bash-function-library -------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to the internet
#
# @author  Joe Mooring, Nathaniel Landau, A. River
#
# @file
# Defines function: bfl::encode_url().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Percent-encodes a URL.
#
# See <https://tools.ietf.org/html/rfc3986#section-2.1>.
#
# @param String $str
#   The string to be encoded.
#
# @return String $str_encoded
#   The encoded string.
#
# @example
#   bfl::encode_url "foo bar"
#------------------------------------------------------------------------------
bfl::urlenc() { bfl::encode_url "$@"; return $?; }  # for compability with Ariver' repository

bfl::encode_url() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || { bfl::error "arguments count $# ≠ 1"; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify argument values.
  bfl::is_blank "$1" && { bfl::error "Argument 1 is blank!"; return ${BFL_ErrCode_Not_verified_arg_values}; }

  # Verify dependencies.
  if bfl::verify_dependencies 'jq'; then
      local rslt  # Build the return value.
      rslt=$(jq -Rr @uri <<< "$1") || { bfl::writelog_fail "${FUNCNAME[0]}: unable to encode url $1."; return 1; }
  else
# ----------------- https://github.com/ariver/bash_functions ------------------
      local {H,OLD,str,rslt}=
      local -i {i,k}=0
      #printf -v TAB "\t"
      #declare LC_ALL="${LC_ALL:-C}"

      OLD="${*}"
      #printf "\n: OLD : %5d : %s\n" "${#OLD}" "${OLD}" 1>&2
      k=${#OLD}
      for ((i=0; i < k; i++)); do
          str="${OLD:$i:1}"
          unset H
          case "$str" in
              ( " " )                        { printf -v H "+"; } ;;
              ( [-=\+\&_.~a-zA-Z0-9:/\?\#] ) { printf -v H %s "$str"; } ;;
              ( * )                          { printf -v H "%%%02X" "'$str"; }
          esac
          rslt+="${H}"
      done
# ---------- https://github.com/natelandau/shell-scripting-templates ----------
#    for ((i = 0; i < ${#1}; i++)); do
#        if [[ ${1:i:1} =~ ^[a-zA-Z0-9\.\~_-]$ ]]; then
#            printf "%s" "${1:i:1}"
#        else
#            printf '%%%02X' "'${1:i:1}"
#        fi
#    done
  fi

  # printf "\n: NEW : %5d : %s\n\n" "${#NEW}" "${NEW}" 1>&2
  printf "%s\\n" "$rslt"  # Print the return value.
  }