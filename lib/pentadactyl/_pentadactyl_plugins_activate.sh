#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to pentadactyl
#
# @author  A. River
#
# @file
# Defines function: bfl::pentadactyl_plugins_activate().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ................................
#
# @example
#   bfl::pentadactyl_plugins_activate
#------------------------------------------------------------------------------
bfl::pentadactyl_plugins_activate() {
  # Verify dependencies.
  bfl::verify_dependencies 'find' 'ln' || return $?

  local ENT
  local -i iErr=0
  cd ~/.pentadactyl/plugins/load/ || { iErr=$?; bfl::error 'Failed cd ~/.pentadactyl/plugins/load/'; return ${iErr}; }
    for ENT in $( find ../../plugins_* -type f -a -name "*.js" -a -print ); do
        {
            printf "\n### %s ###\n\n" "${ENT#*/plugins_}"
            read -p "? " -n1
            echo
            [[ "${REPLY}" != [yY] ]] || ln -vnfs "${ENT}"
        } 1>&2
    done
  }