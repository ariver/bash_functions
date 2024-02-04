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
# Defines function: bfl::brew_uninstall().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Uninstalls brew.
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::brew_uninstall
#------------------------------------------------------------------------------
bfl::brew_UNINSTALL() { bfl::brew_uninstall "$@"; } # for compability with Ariver' repository

bfl::brew_uninstall() {
  # Verify dependencies.
  bfl::verify_dependencies 'brew' 'find' 'git' 'xargs' || return $?

  local {fnc,ents,ent}=
  fnc="${FUNCNAME[0]}"
  ents=(
      Library/Aliases
      Library/Contributions
      Library/Formula
      Library/Homebrew
      Library/LinkedKegs
      Library/Taps
      .git
      '~/Library/*/Homebrew'
      '/Library/Caches/Homebrew/*'
  )

  hash -r
  export HOMEBREW_PREFIX
  HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$( brew --prefix )}"

  {
      [[ -n "${HOMEBREW_PREFIX}" ]] || { bfl::error "could not determine HOMEBREW_PREFIX"; return 1; }

      cd "${HOMEBREW_PREFIX}"/. >/dev/null 2>&1
      [[ $? -eq 0 ]] || { bfl::error "could not change directory '${HOMEBREW_PREFIX}'"; return 1; }

      if [[ -e Cellar/. ]]; then
          printf "${fnc}: %s\n" "Removing Cellar"
          command rm -rf Cellar || { bfl::error "error 'command rm -rf Cellar'"; return 255; }
      fi

      if [[ -x bin/brew ]]; then
          printf "${fnc}: %s\n" "Brew Pruning"
          bin/brew prune || { bfl::error "error 'bin/brew prune'"; return 254; }
      fi

      if [[ -d .git/. ]]; then
          printf "${fnc}: %s\n" "Removing GIT Data"
          git checkout -q master || { bfl::error "error 'git checkout -q master'"; return 253; }
          { git ls-files | tr '\n' '\0' | xargs -0 rm -f; } || { bfl::error "error 'git ls-files | tr '\n' '\0' | xargs -0 rm -f'"; return 252; }
      fi

      for ent in "${ents[@]}"; do
          [[ -n "${ent}" ]] || continue
          if [[ $( eval ls -1d "${ent}" >/dev/null 2>&1 ) ]]; then
              printf "${fnc}: %s\n" "Removing { ${ent} }"
              eval command rm -rf "${ent}"
          fi
      done

      [[ $BASH_INTERACTIVE == true ]] && printf "${fnc}: %s\n" "Removing Broken SymLinks"
      find -L . -type l -exec rm -- {} +
      [[ $BASH_INTERACTIVE == true ]] && printf "${fnc}: %s\n" "Removing Empty Dirs"
      find . -depth -type d -empty -exec rmdir -- '{}' \; 2>/dev/null

  } 1>&2

  }