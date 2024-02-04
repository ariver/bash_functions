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
# Defines function: bfl::brew_upup().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Guided brew update/upgrade/cleanup
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::brew_upup
#------------------------------------------------------------------------------
bfl::brew_upup() {
  # Verify dependencies.
  bfl::verify_dependencies 'brew' || return $?

  local tmp=

  {
      brew update   # First update brew.
      # Any outdated packages found?
      tmp="$( brew outdated )"
      if [[ -n "${tmp}" ]]; then
          # Show outdated packages and confirm upgrade.
          if [[ $BASH_INTERACTIVE == true ]]; then
              printf "\n"
              brew outdated
              printf "\nUpgrade? [y/N] "
              read -n1
              printf "\n"
              [[ "${REPLY,,}" == [y] ]] && brew upgrade --all
          else
              brew upgrade --all
          fi
      else
          [[ $BASH_INTERACTIVE == true ]] && printf "No outdated brews.\n"
      fi

      # Any cleanup needed?
      tmp="$( brew cleanup -n )"
      if [[ -n "${tmp}" ]]; then
          # Show cleanup needed and confirm removal.
          if [[ $BASH_INTERACTIVE == true ]]; then
              printf "\n%s\n\nCleanup? [y/N] " "${tmp}"
              read -n1
              printf "\n"
              [[ "${REPLY,,}" == [y] ]] && brew cleanup
          else
              brew cleanup
          fi
      else
          [[ $BASH_INTERACTIVE == true ]] && printf "No brews to cleanup.\n"
      fi

  } 1>&2

  }