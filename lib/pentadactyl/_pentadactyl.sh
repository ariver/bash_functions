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
# Defines functions:
#                   bfl::pentadactyl_history_commands_dts()
#                   bfl::pentadactyl_history_sets_dts()
#                   bfl::pentadactyl_history_sets_latest_dts().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ................................
#
# @example
#   bfl::pentadactyl_history_commands_dts
#   bfl::pentadactyl_history_sets_dts
#   bfl::pentadactyl_history_sets_latest_dts
#------------------------------------------------------------------------------
bfl::pentadactyl_history_commands_dts() {
  bfl::pentadactyl_history_commands | bfl::___pentadactyl_history_dts
  }

bfl::pentadactyl_history_sets_dts() {
  bfl::pentadactyl_history_sets | bfl::___pentadactyl_history_dts
  }

bfl::pentadactyl_history_sets_latest_dts() {
  bfl::pentadactyl_history_sets_latest | bfl::___pentadactyl_history_dts
  }
