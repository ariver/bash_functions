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
# Defines function: bfl::git_fetch_merge().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Fetches "upstream" and merges "upstream/master" "master"
#
# @param String $stream_and_branch
#   Stream / branch.
#
# @param String $branch2  (optional)
#   Branch №2.
#
# @return Boolan $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::git_fetch_merge "upstream/master" master
#------------------------------------------------------------------------------
bfl::git_hub_upstream_fetch_merge() {
  # Verify arguments count.
  (( $# > 0 && $# < 2 )) || { bfl::error "arguments count $# ∉ [0..1]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify dependencies.
  bfl::verify_dependencies 'git' || return $?

  local -r stream="${1##*/}"
  local -r branch1="${1%/*}"

  bfl::is_blank "$stream"  && { bfl::error "git stream name is required."; return ${BFL_ErrCode_Not_verified_arg_values}; }
  bfl::is_blank "$branch1" && { bfl::error "git branch name of stream is required."; return ${BFL_ErrCode_Not_verified_arg_values}; }

  local -r branch2="${2:-$branch1}"

  git remote -v
  git fetch "$stream"       || { iErr=$?; bfl::error "Failed git fetch '$1'"; return ${iErr}; }
  git merge "$1" "$branch2" || { iErr=$?; bfl::error "Failed git merge '$1' '$branch2'"; return ${iErr}; }
  }