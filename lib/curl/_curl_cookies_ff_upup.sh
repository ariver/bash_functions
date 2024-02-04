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
# Defines function: bfl::curl_cookies_ff_upup().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ..............................
#
# @param String $firefox_profiles
#   Firefox profiles directory.
#
# @param String $firefox_cookies  (may be not exists)
#   Firefox cookies directory.
#
# @example
#   bfl::curl_cookies_ff_upup "$HOME/Library/Application Support/Firefox/Profiles" ~/.curl/cookies_ff
#------------------------------------------------------------------------------
bfl::curl_cookies_ff_upup() {
  # Verify arguments count.
  (( $# < 3 )) || { bfl::error "arguments count $# ∉ [0..2]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify argument values.
  (( $# > 0 )) && bfl::is_blank "$1" && { bfl::error "Firefox profiles folder is blank."; return ${BFL_ErrCode_Not_verified_arg_values}; }
  [[ $# -eq 2 ]] && bfl::is_blank "$2" && { bfl::error "Firefox cookies_ff is blank."; return ${BFL_ErrCode_Not_verified_arg_values}; }

  # Verify dependencies.
  bfl::verify_dependencies 'cat' 'diff' 'find' 'sqlite3' || return $?

  profiles_folder=${1:-"~/Library/Application Support/Firefox/Profiles"}
  [[ -d "${profiles_folder}" ]] || mkdir -p "${profiles_folder%/*}" || { bfl::error "Firefox profiles folder '$profiles_folder' cannot be created!"; return ${BFL_ErrCode_Not_verified_arg_values}; }
  file_cookies=${2:-~/.curl/cookies_ff}

  local -- tc_htab
  local -- file_cookies profiles_folder ff_profile

  printf -v tc_htab '\t'

  mkdir -p "${file_cookies%/*}"
  ff_profile="$(
        find \
                "${profiles_folder}"/*.default/. \
                -maxdepth 0 \
                -type d \
                -print0 \
                | xargs -0 ls -1drt \
                | tail -1
    )"

  command cp -af "${file_cookies}"{,.0} 2>/dev/null

            #'select host, "TRUE", path, case isSecure when 0 then "FALSE" else "TRUE" end, expiry, name, value from moz_cookies'
  sqlite3 \
            -separator "${tc_htab}" \
            "${ff_profile}/cookies.sqlite" \
            " \
                select \
                    host as domain, \
                    case substr(host,1,1)='.' when 0 then 'FALSE' else 'TRUE' end as flag, \
                    path, \
                    case isSecure when 0 then 'FALSE' else 'TRUE' end as secure, \
                    expiry as expiration, \
                    name, \
                    value
                from \
                    moz_cookies \
            " \
        > "${file_cookies}".1

  cat "${file_cookies}".[01] 2>/dev/null \
        | grep -n . \
        | sort -t: -k 2,99 -k 1,1gr \
        | sort -t: -k 2,99 -u \
        | sort -t: -k 1,1g \
        | cut -d: -f2- \
        > "${file_cookies}".9

  if ! diff "${file_cookies}"{,.9} 2>/dev/null ; then
      [[ -s "${file_cookies}".9 ]] && command cp -vf "${file_cookies}"{.9,}
  fi
  command rm -vf "${file_cookies}".?
  }