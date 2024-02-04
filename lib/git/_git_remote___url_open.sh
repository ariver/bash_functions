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
# Defines function: bfl::git_remote___url_open().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ..............................
#
# @example
#   bfl::git_remote_origin_url_open
#   bfl::git_remote_upstream_url_open
#------------------------------------------------------------------------------

# for compability with Ariver' repository
function git_remote_origin_url_open()   { bfl::git_remote_origin_url_open "$@";   return $?; }
function git_remote_upstream_url_open() { bfl::git_remote_upstream_url_open "$@"; return $?; }

bfl::git_remote_origin_url_open() { bfl::git_remote___url_open origin "${@}"; return $?; }

bfl::git_remote_upstream_url_open() { bfl::git_remote___url_open upstream "${@}"; return $?; }

bfl::git_remote___url_open() {
  # Verify dependencies.
  bfl::verify_dependencies 'git' || return $?

  declare vars=(
        dirs dir
        src
        url
        typ
    )
  declare ${vars[*]}
  typ="${1}"; shift
  dirs=( "${@}" )
  [[ "${#@}" -gt 0 ]] || dirs=( . )
  for dir in "${dirs[@]}"; do
      src="$( git config remote.${typ}.url )"
      printf "# %s\t= %s\t@ " "${dir}" "${src}"
      [[ "${src}" =~ ^([^@]*)@([^:/]*):(.*)$ ]] && url="https://${BASH_REMATCH[2]}/${BASH_REMATCH[3]%.git}"
      printf "%s\n" "${url}"
      [[ -z "${url}" ]] || { open "${url}"; continue; }
      printf "  Did not open URL\n"
  done
  }