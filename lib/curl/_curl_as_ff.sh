#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to cUrl
#
# @author  A. River
#
# @file
# Defines function: bfl::curl_as_ff().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Runs curl with Mozilla header.
#
# @param String $firefox_cookies
#   Firefox cookies directory.
#
# @param String $curl_args
#   curl arguments. Remainder of arguments can be pretty much anything you would otherwise provide to curl.
#
# @example
#   bfl::curl_as_ff ~/.curl/cookies_ff ...
#------------------------------------------------------------------------------
bfl::curl_as_ff() {
  # Verify arguments count.
  (( $# > 0 && $# < 1000 )) || { bfl::error "arguments count $# ∉ [1..999]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify argument values.
  (( $# > 0 )) && bfl::is_blank "$1" && { bfl::error "Firefox cookies is blank."; return ${BFL_ErrCode_Not_verified_arg_values}; }

  # Verify dependencies.
  bfl::verify_dependencies 'curl' || return $?

  local -- tc_htab file_cookies head_useragent
  printf -v tc_htab '\t'

  file_cookies=${1:-~/.curl/cookies_ff}
  head_useragent='Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:47.0) Gecko/20100101 Firefox/47.0'

  curl -A "${head_useragent}" -b "${file_cookies}" -c "${file_cookies}" "$@"
  }
