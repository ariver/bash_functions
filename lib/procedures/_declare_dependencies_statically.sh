#!/usr/bin/env bash
# Prevent this file from being sourced more than once (from Jarodiv)
[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# --------- https://github.com/AlexeiKharchev/bash_functions_library ----------
#
# Library of internal library functions
#
# @author  Alexei Kharchev
#
# @file
# Defines function: bfl::declare_dependencies_statically().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Declare whole list dependencies
#
# @example
#   bfl::declare_dependencies_statically 'sed' 'grep' 'head' ...
#------------------------------------------------------------------------------
bfl::declare_dependencies_statically() {
  # Verify arguments count.
  (( $# > 0 && $# < 1000 )) || { bfl::error "arguments count $# ∉ [1..999]"; return ${BFL_ErrCode_Not_verified_args_count}; }

  # grep -rnw lib/* -e 'bfl::verify_dependencies' | sed -n '/^[^:]*_verify_dependencies.sh:/!p' | sed 's/#.*$//' | sed 's/#.*$//' | sed 's/^.*bfl::verify_dependencies \([^|]*\) ||.*$/\1/' | sed 's/^.*bfl::verify_dependencies \([^\&]*\) \&\&.*$/\1/' | sed 's/^"\(.*\)"[ ]*$/\1/' | sort | uniq

  local {f,h}=
  for f in "$@"; do
      h="${f/-/_}"
      h="_BFL_HAS_${h^^}"
      [[ ${!h} -eq 1 ]] && continue

      bfl::command_exists "$f" && readonly "$h"=1 # || readonly "$h"=0
  done
  }