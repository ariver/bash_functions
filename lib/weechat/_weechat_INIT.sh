#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to weechat
#
# @author  A. River
#
# @file
# Defines function: bfl::weechat_init().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Exports 2 weechat variables.
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::weechat_init
#------------------------------------------------------------------------------
bfl::weechat_INIT() {
  # Verify arguments count.
  #(( $# > 0 && $# < 2 )) || { bfl::error "arguments count $# ∉ [1..2]."; return ${BFL_ErrCode_Not_verified_args_count}; }

    : ${WEECHAT_HOME_DIR:=~/.weechat}
    : ${WEECHAT_LOG_DIR:=${WEECHAT_HOME_DIR}/logs}

  local {IFS,ents,ent,tmp}=
    printf -v IFS   ' \t\n'
    ents=(
        WEECHAT_HOME_DIR
        WEECHAT_LOG_DIR
    )

  for ent in "${ents[@]}"; do
      printf -v tmp 'tmp="${%s}"' "${ent}"
      eval "${tmp}"
      [[ -r "${tmp}" ]] || { bfl::error "Could not find ${ent} ( ${tmp} )!"; return 1; }
      export "${ent}"
  done 1>&2
  }