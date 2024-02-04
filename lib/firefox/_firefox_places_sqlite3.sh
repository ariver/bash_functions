#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to Firefox
#
# @author  A. River
#
# @file
# Defines function: bfl::firefox_places_sqlite3().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Runs curl with Mozilla header.
#
# @param String $firefox_profiles
#   Firefox profiles directory.
#
# @param String $args
#   sqlite3 arguments. Remainder of arguments can be pretty much anything you would otherwise provide to sqlite3.
#
# @example
#   bfl::firefox_places_sqlite3 "$HOME/Library/Application Support/Firefox/Profiles" ...
#------------------------------------------------------------------------------
bfl::Firefox_places_sqlite3() { bfl::firefox_places_sqlite3 "$@"; return $?; } # for compability with Ariver' repository

bfl::firefox_places_sqlite3() {
  # Verify arguments count.
  (( $# > 0 && $# < 1000 )) || { bfl::error "arguments count $# ∉ [1..999]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify argument values.
  bfl::is_blank "$1" && { bfl::error "Firefox profiles folder is required.";        return ${BFL_ErrCode_Not_verified_arg_values}; }
  [[ -d "$1" ]]      || { bfl::error "Firefox profiles folder '$1' doesn't exist!"; return ${BFL_ErrCode_Not_verified_arg_values}; }
  profiles_folder=${1:-"~/Library/Application Support/Firefox/Profiles"}; shift

  # Verify dependencies.
  bfl::verify_dependencies 'tail' 'sqlite3' || return $?

  local {ent,opts,sqls,places}=
  local -i {iErr,opt_done}=0
  places="$( ls -1rt ${profiles_folder}/*/places.sqlite | tail -1 )"
  opts=(); sqls=()
  for ent in "${@}"; do
      [[ "${ent}" == '--' ]] && { opt_done=1; continue; }
      [[ "${opt_done}" -gt 0 ]] && sqls[${#sqls[@]}]="${ent}" || opts[${#opts[@]}]="${ent}"
  done

  sqlite3 "${opts[@]}" "${places}" "${sqls[@]}" || { iErr=$?; bfl::error "Failed command 'sqlite3 '${opts[0]} ...' '${places}' '${sqls[@]}'"; return ${iErr}; }
  }