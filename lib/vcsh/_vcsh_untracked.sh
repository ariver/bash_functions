#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to the vcsh
#
# @author  A. River
#
# @file
# Defines function: bfl::vcsh_untracked().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ..............................
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::vcsh_untracked
#------------------------------------------------------------------------------
bfl::vcsh_untracked() {
  # Verify dependencies.
  bfl::verify_dependencies 'sed' 'sort' 'vcsh' || return $?

  printf '/%s\n' \
      .DS_Store .Trash .cache .local .opt .rnd Applications Desktop Documents Downloads Library Maildirs Movies Music Pictures Public
  vcsh list-tracked |
            sed "s=^${HOME}\(/[^/]*\).*=\1=" |
            sort -u
    } > "${XDG_CONFIG_HOME:-${HOME}/.config}/vcsh/ignore.d/vcsh-untracked"
  vcsh run vcsh-untracked git status -sb
  }