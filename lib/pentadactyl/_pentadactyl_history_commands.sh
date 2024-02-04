#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to pentadactyl
#
# @author  A. River
#
# @file
# Defines function: bfl::pentadactyl_history_commands().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ................................
#
# @example
#   bfl::pentadactyl_history_commands
# shellcheck disable=SC2016
#------------------------------------------------------------------------------
bfl::pentadactyl_history_commands() {
  # Verify dependencies.
  bfl::verify_dependencies 'find' 'json2path' || return $?

  local -i iErr=0   # variables declarations
  eval "$( bfl::___pentadactyl_common_source )" || { iErr=$?; bfl::error 'eval $( bfl::___pentadactyl_common_source )'; return ${iErr}; }

    local {tmp,ent,cmd,prv,val,dts}=
    tmp="${TMPDIR:-/tmp}/.pentadactyl.history.tmp"
    find "${tmp}" -mmin +1 -ls -exec rm -f "{}" \; 1>&2 2>/dev/null
    [[ -f "${tmp}" ]] || {
        for ent in ~/.pentadactyl/info/*/command-history; do
            json2path < "${ent}" >> "${tmp}"
        done
    }
    while read -r ent; do
        [[ "${ent}" =~ ^/command\[([0-9]+)\]/(privateData|value|timestamp)=(.*) ]] || continue
        [ "${BASH_REMATCH[1]}" == "${cmd}" ] || { cmd="${BASH_REMATCH[1]}"; prv=; val=; dts=; }
        case "${BASH_REMATCH[2]}" in
            ( privateData ) prv="${BASH_REMATCH[3]}";;
            ( value )       { val="${BASH_REMATCH[3]%\"}"; val="${val#\"}"; } ;;
            ( timestamp )   dts="${BASH_REMATCH[3]}";;
        esac
        [ -z "${prv}" -o -z "${val}" -o -z "${dts}" ] || printf "%s\t%s\t%s\n" "${dts}" "${prv}" "${val}"
    done < "${tmp}"
  }