#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to Bash
#
# @author  A. River
#
# @file
# Defines function: bfl::bash_compgen_shortcuts().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   This is just a temporary function that generates the compgen shortcut functions.
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::bash_compgen_shortcuts
#------------------------------------------------------------------------------
function ___tmp() { bfl::bash_compgen_shortcuts; return $?; } # for compability with Ariver' repository

bfl::bash_compgen_shortcuts() {

  local {act,cmd,tag}=
  local acts=(
      alias:a
      arrayvar:ary
      binding:bnd
      builtin:b
      command:c
      directory:d
      disabled:dis
      enabled:enb
      export:e
      file:fi
      function:f
      group:g
      helptopic:hlp
      hostname:h
      job:j
      keyword:k
      running:r
      service:svc
      setopt:set
      shopt:sho
      signal:sig
      stopped:stp
      user:u
      variable:v
      )

  for act in ${acts[*]}; do
      tag="${act#*:}"
      act="${act%:*}"
      printf -v cmd 'function compg%s () { declare I; for I in ${@:+"${@}"}; do compgen -A %s "${I}"; done; }' "${tag}" "${act}"
      eval "${cmd}"
  done
  }

___tmp 1>&2
unset -f ___tmp
