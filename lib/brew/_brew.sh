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
# Defines function: bfl::brew().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Clean run of Homebrew.
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::brew
#------------------------------------------------------------------------------
# for compability with Ariver' repository

# brew install
function brewI() { brew_actioner "$@"; }

# brew uninstall
function brewU() { brew_actioner "$@"; }

# brew update
function brewu() { brew_actioner "$@"; }

# brew upgrade
function brewUp() { brew_actioner "$@"; }

# brew uninstall/install (actual-reinstall)
function brewR() { brew_actioner "$@"; }

# brew home
function brewh() { brew_actioner "$@"; }

# brew search
function brews() { brew_actioner "$@"; }

# brew list
function brewl() { brew_actioner "$@"; }

# brew info
function brewi() { brew_actioner "$@"; }

#function brew () {
#    # Verify dependencies.
#    [[ ${_BFL_HAS_BREW} -eq 1 ]] || { bfl::error "dependency 'brew' not found"; return ${BFL_ErrCode_Not_verified_dependency}; }
#
#    # Obtain Homebrew prefix.
#    declare prefix="$( command brew --prefix )"
#
#    # Only change PATHs for this function and any sub-procs
#    declare -x PATH MANPATH
#
#    # Reset PATHs
#    eval "$( PATH= MANPATH= /usr/libexec/path_helper -s )"
#
#    # Add Homebrew PATHs
#    PATH="${prefix}/bin:${prefix}/sbin:${PATH}"
#    MANPATH="${prefix}/man:${MANPATH}"
#
#    # Run Homebrew
#    hash -r
#    command brew "$@"
#
#}