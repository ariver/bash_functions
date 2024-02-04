#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
# ------------------------ https://github.com/xenoxaos ------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
# ---------------- Thanks to xenoxaos for the inspiration! =] -----------------
#
# Library of functions related to cUrl
#
# @author  A. River
#
# @file
# Defines function: bfl::whoish().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Runs curl with web_address from http://whois.arin.net/.
#
# @param String $web_address
#   Part of http://whois.arin.net/ url.
#
# @example
#   bfl::whoish %web_address%
#------------------------------------------------------------------------------
bfl::whoish() {
  # Verify arguments count.
  (( $# > 0 && $# < 1000 )) || { bfl::error "arguments count $# ∉ [1..999]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify argument values.
  bfl::is_blank "$1" && { bfl::error "Argument 1 (web_address) is required."; return ${BFL_ErrCode_Not_verified_arg_values}; }

  # Verify dependencies.
  bfl::verify_dependencies 'curl' 'jq' || return $?

  local {curl_cmd,json,jq_flt,urls,url}=
    #
    printf -v jq_flt %s \
        '.nets.net' \
        ' | ' \
            'if ( . | type ) == "object" then' \
                ' . ' \
            'elif ( . | type ) == "array" then' \
                ' .[] ' \
            'else' \
                ' "ERR" ' \
            'end' \
            ' | ' \
                '.ref["$"] , .orgRef["$"]'
    curl_cmd=(
        curl -s
        -H 'Accept: application/json'
        "http://whois.arin.net/rest/nets;q=${1}?showDetails=true"
    )
    #
    json="$( "${curl_cmd[@]}" )"
    #
    urls=( $( echo "${json}" | jq "${jq_flt}" ) )
    #
    curl -s -H 'Accept: text/plain' "${urls[@]//\"/}" |
        grep -v '^#' |
        uniq
  }