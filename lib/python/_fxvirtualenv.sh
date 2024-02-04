#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to Python
#
# @author  A. River
#
# @file
# Defines function: bfl::fxvirtualenv().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Loads virtualenv
#
# @example
#   bfl::fxvirtualenv
#------------------------------------------------------------------------------
bfl::fxvirtualenv() {

  # Verify dependencies.
  bfl::verify_dependencies 'deactivate' 'find' 'virtualenv' 'workon' || return $?

    local {sdir,vhom,vdir,venv,vflg}=
    local -i iErr=0

    sdir="${PWD}"
    vhom="${WORKON_HOME:-${VIRTUALENVWRAPPER_HOOK_DIR}}"
    vdir="${VIRTUAL_ENV}"
    venv="${1}"
    if [[ -n "${venv}" ]]; then
        vflg=0
        vdir="${vhom}/${venv}"
        [[ -e "${vdir}" ]] || vdir=
    else
        vflg=1
    fi
    [[ -z "${vdir}" ]] && { workon; return $?; }

    venv="${vdir##*/}"
    deactivate > /dev/null 2>&1
    find -L "${vdir}" -type l -exec rm -vf '{}' \
    cd "${vdir}" || { iErr=$?; bfl::error "failed cd '${vdir}'"; return ${iErr}; }
    virtualenv .
    cd "${sdir}" || { iErr=$?; bfl::error "failed cd '${sdir}'"; return ${iErr}; }
    [[ "${vflg}" -ne 0 ]] && workon "${venv}"
  }