#!/usr/bin/env bash
# Prevent this file from being sourced more than once
[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to Git commands
#
# @author  A. River
#
# @file
# Defines functions:
#                   bfl::gitp()
#                   bfl::gitP()
#                   bfl::gita()
#                   bfl::gitd()
#                   bfl::gits()
#                   bfl::gitc()
#                   bfl::gitC0()
#                   bfl::gitC1()
#                   bfl::gitC2()
#                   bfl::gitC3()
#                   bfl::gitC4()
#------------------------------------------------------------------------------

# for compability with Ariver' repository
function gitp() { bfl::gitp "$@"; return $?; }
function gitP() { bfl::gitP "$@"; return $?; }
function gita() { bfl::gita "$@"; return $?; }
function gitd() { bfl::gitd "$@"; return $?; }
function gits() { bfl::gits "$@"; return $?; }
function gitc() { bfl::gitc "$@"; return $?; }
function gitC0() { bfl::gitC0 "$@"; return $?; }
function gitC1() { bfl::gitC1 "$@"; return $?; }
function gitC3() { bfl::gitC3 "$@"; return $?; }
function gitC4() { bfl::gitC4 "$@"; return $?; }

bfl::gitp() {
  # Verify dependencies.
  bfl::verify_dependencies 'git' || return $?

  git pull "${@}"
  }

bfl::gitP() {
  # Verify dependencies.
  bfl::verify_dependencies 'git' || return $?

  git push "${@}"
  }

bfl::gita() {
  # Verify dependencies.
  bfl::verify_dependencies 'git' || return $?

  git add "${@}"
  }

bfl::gitd() {
  # Verify dependencies.
  bfl::verify_dependencies 'git' || return $?

  git diff "${@}"
  }

bfl::gits() {
  # Verify dependencies.
  bfl::verify_dependencies 'git' || return $?

  git status -sb "${@}"
  }

bfl::gitc() {
  # Verify dependencies.
  bfl::verify_dependencies 'git' || return $?

  git commit "${@}"
  }

bfl::gitC0() {
  # Verify dependencies.
  bfl::verify_dependencies 'git' || return $?

  git commit -m "lazy.. no notes" "${@}"
  }

bfl::gitC1() {
  # Verify dependencies.
  bfl::verify_dependencies 'git' || return $?

  git commit -m "meh.. whitespace" "${@}"
  }

bfl::gitC3() {
  # Verify dependencies.
  bfl::verify_dependencies 'git' || return $?

  git commit -m "code comments" "${@}"
  }

bfl::gitC4() {
  # Verify dependencies.
  bfl::verify_dependencies 'git' || return $?

  git commit -m "restructuring" "${@}"
  }