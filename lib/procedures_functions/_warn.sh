#!/usr/bin/env bash

[[ -z $(echo "$BASH_SOURCE" | sed -n '/bash_functions_library/p') ]] && return 0 || _bfl_temporary_var=$(echo "$BASH_SOURCE" | sed 's|^.*/lib/\([^/]*\)/\([^/]*\)\.sh$|_GUARD_BFL_\1\2|')
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly $_bfl_temporary_var=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
# @file
# Defines function: bfl::warn().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Prints a warning message to stderr.
#
# The message provided will be prepended with "Warning. "
#
# @param string $msg (optional)
#   The message.
#
# @example
#   bfl::warn "The foo is bar."
#
# shellcheck disable=SC2154
#------------------------------------------------------------------------------
bfl::warn() {
  bfl::verify_arg_count "$#" 0 1 || exit 1  # Verify argument count.

  # Declare positional arguments (readonly, sorted by position).
  local msg="${1:-"Unspecified warning."}"

  # Print the message.
  printf "%b\\n" "${bfl_aes_yellow}Warning. $msg${bfl_aes_reset}" 1>&2
  }
