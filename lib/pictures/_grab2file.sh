#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to screen and pictures.
#
# @author  A. River
#
# @file
# Defines function: bfl::grab2file().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Captures screen to file.
#
# @param String $path
#   Directory to save capture.
#
# @param String $file_mask (optional)
#   File mask to save picture
#
# @example
#   bfl::grab2file
#------------------------------------------------------------------------------
bfl::grab2file() {
  # Verify arguments count.
  (( $# > 0 && $# < 2 )) || { bfl::error "arguments count $# ∉ [1..2]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify argument values.
  bfl::is_blank "$1" && { bfl::error "path is required."; return ${BFL_ErrCode_Not_verified_arg_values}; }
  [[ -d "$1" ]] || install -v -d "$1" || { bfl::error "Failed install -v -d '$1'"; return ${BFL_ErrCode_Not_verified_arg_values}; }
  [[ -d "$1" ]] || { bfl::error "cannot create directory '$1'"; return ${BFL_ErrCode_Not_verified_arg_values}; }

  # Verify dependencies.
  bfl::verify_dependencies 'screencapture' || return $?

  local -r file_mask=${2:-grab2file}
  local -r f="$1"/"${file_mask}_$( date '+%Y-%m-%d_%H-%M-%S' ).png"    # ~/Documents/Screenies

  [[ $BASH_INTERACTIVE == true ]] && printf '\n# Interactive capture to ( %s )\n\n' "${f}"
  screencapture -io "${f}" || { bfl::error "Failed screencapture -io '$f'"; return ${BFL_ErrCode_Not_verified_arg_values}; }

  echo "$f"
  }