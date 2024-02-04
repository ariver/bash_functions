#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to brew
#
# @author  A. River
#
# @file
# Defines function: bfl::brew_status().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Brew package status modeled after output of aptitude
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::brew_status
#------------------------------------------------------------------------------
bfl::brew_stat() { bfl::brew_status "$@"; } # for compability with Ariver' repository

bfl::brew_status() {
  # Verify dependencies.
  bfl::verify_dependencies 'brew' 'sed' || return $?

  declare -x IFS
  local -a {brews_ents,brewl_ents}
  local {tc_tab,ent}=

  printf -v tc_tab '\t'
  printf -v IFS    '\n'

  for ent in "${@}"; do
      brews_ents=( "${brews_ents[@]}" $( brew search "${ent}" ) )
  done

  for ent in "${brews_ents[@]}"; do
      brewl_ents=( "${brewl_ents[@]}" $( brew list | grep -i "${ent}" ) )
  done

  comm <( printf '%s\n' "${brews_ents[@]}" ) <( printf '%s\n' "${brewl_ents[@]}" ) |
      sed -e "s/^${tc_tab}${tc_tab}/i   /;tEND" \
          -e "s/^${tc_tab}/i?  /;tEND" \
          -e "s/^/p   /;tEND" \
          -e :END
  }