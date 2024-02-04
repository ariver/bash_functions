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
bfl::brewI() { bfl::brew_actioner "$@"; }

# brew uninstall
bfl::brewU() { bfl::brew_actioner "$@"; }

# brew update
bfl::brewu() { bfl::brew_actioner "$@"; }

# brew upgrade
bfl::brewUp() { bfl::brew_actioner "$@"; }

# brew uninstall/install (actual-reinstall)
bfl::brewR() { bfl::brew_actioner "$@"; }

# brew home
bfl::brewh() { bfl::brew_actioner "$@"; }

# brew search
bfl::brews() { bfl::brew_actioner "$@"; }

# brew list
bfl::brewl() { bfl::brew_actioner "$@"; }

# brew info
bfl::brewi() { bfl::brew_actioner "$@"; }

#bfl::brew () {
#  # Verify dependencies.
#  bfl::verify_dependencies 'brew' || return $?
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