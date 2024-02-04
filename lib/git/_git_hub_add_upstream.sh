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
# Defines function: bfl::git_hub_add_upstream().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Adds remote add upstream
#
# @param String $_path (optional)
#   Directory. (Default `pwd`)
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::git_hub_add_upstream  "/some path"
#------------------------------------------------------------------------------
bfl::git_hub_add_upstream() {
  # Verify arguments count.
  (( $# < 2 )) || { bfl::error "arguments count $# ∉ [0..1]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify argument values.
  if [[ $# -eq 1 ]]; then
      bfl::is_blank "$1" && { bfl::error "directory is blank."; return ${BFL_ErrCode_Not_verified_arg_values}; }
      [[ -d "$1" ]] || { bfl::error "directory '$1' doesn't exist!"; return ${BFL_ErrCode_Not_verified_arg_values}; }
  fi

  # Verify dependencies.
  bfl::verify_dependencies 'git' || return $?

  [[ -z ${1} ]] && local -r _path=$(pwd) || local -r _path="$1"

  local {repo,repo_up,repo_up_url}=
  repo="${_path#*/Source/*/}"
  repo="${repo%.git}"
  repo_up="$( git hub repo-get "${repo}" source/full_name )"
  repo_up_url="$( git hub repo-get "${repo_up}" ssh_url )"
  [[ -n "${repo_up_url}" ]] || { bfl::error "command 'git hub repo-get '${repo_up}' ssh_url' returns empty result"; return 1; }

  local -p repo repo_up repo_up_url
  git remote add upstream "${repo_up_url}"
  git remote -v
  }