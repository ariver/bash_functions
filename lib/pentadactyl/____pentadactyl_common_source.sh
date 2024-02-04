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
# Defines function: bfl::pentadactyl_common_source().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Declares common variables for pentadactyl functions
#
# @example
#   bfl::pentadactyl_common_source
#------------------------------------------------------------------------------
bfl::___pentadactyl_common_source() {

    declare vars=(
        tmp
        tc_tab
        ent
        cmd
        prv
        val
        dts
    )
    declare ${vars[*]}

    printf -v tc_tab '\t'

    declare -p ${vars[*]}
  }