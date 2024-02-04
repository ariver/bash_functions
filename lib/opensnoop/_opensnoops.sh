#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to opensnoops
#
# @author  A. River
#
# @file
# Defines function: bfl::opensnoops().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Runs opensnoops from sudo with parameters.
#
# @param String $opensnoop_args
#   opensnoop arguments. Remainder of arguments can be pretty much anything you would otherwise provide to opensnoop.
#
# @return String $result
#   Text.
#
# @example
#   bfl::opensnoops ...
#------------------------------------------------------------------------------
bfl::opensnoops() {
  # Verify arguments count.
  (( $# > 0 && $# < 1000 )) || { bfl::error "arguments count $# ∉ [1..999]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify dependencies.
  bfl::verify_dependencies 'grep' 'opensnoops' || return $?

  local {{O,G}_ARGS,ARG,FLG}=
  O_ARGS=(); G_ARGS=()
  for ARG in ${@:+"${@}"}; do
      [[ "${ARG}" == "--" ]] && FLG="G" && continue
      [[ "${FLG}" == "G" ]] \
            && G_ARGS[${#G_ARGS[@]}]="${ARG}" \
            || O_ARGS[${#O_ARGS[@]}]="${ARG}"
  done
  sudo opensnoop ${O_ARGS[*]:+"${O_ARGS[@]}"} 2>&1 |
        grep --line-buffered "${G_ARGS[@]:-}"
  }