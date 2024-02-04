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
# Defines function: bfl::pip_list_vers().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Installs modules with defined version
#
# @param String $pkg_list
#   Python modules list.
#
# @example
#   bfl::pip_list_vers
#------------------------------------------------------------------------------
bfl::pip_list_vers() {
  # Verify dependencies.
  bfl::verify_dependencies 'sed' 'pip' || return $?

  local pkg
  for pkg in "${@}"; do
      printf '%s # ' "${pkg}"
      pip install "${pkg}"==_ 2>&1 | sed -n 's/, / /g;s/^[[:blank:]]*Could not find a version that satisfies the requirement .*==_ (from versions: \(.*\)).*/\1/p'
  done
  }