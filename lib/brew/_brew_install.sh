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
# Defines function: bfl::brew_install().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Loads brew from web and installs to directory.
#
# @param String $path
#   Directory to make backup.
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::brew_install '/usr/local'
#------------------------------------------------------------------------------
bfl::brew_INSTALL() { bfl::brew_install "$@"; return $?; } # for compability with Ariver' repository

bfl::brew_install() {
  # Verify arguments' values.
  bfl::is_blank "$1" && { bfl::error "path is required."; return ${BFL_ErrCode_Not_verified_arg_values}; }
  [[ -z "$1" ]] || [[ -d "$1" ]] || install -v -d "$1" || { bfl::error "failed 'install -v -d '$1'"; return ${BFL_ErrCode_Not_verified_arg_values}; }

  # Verify dependencies.
  bfl::verify_dependencies 'curl' 'ruby' || return $?

  local {fnc,precmd,umask_bak,dest}=
  fnc="${FUNCNAME[0]}"
  local -i cmderr=0
  umask_bak="$( umask )"
  umask 0002
  dest="${1:-/usr/local}"

  {
      [[ $BASH_INTERACTIVE == true ]] && printf "${fnc}: %s\n" "Setting up { $dest }"
      while :; do
          {
          "${precmd[@]}" mkdir -p           "$dest"/bin
          "${precmd[@]}" chgrp -R admin     "$dest"/.
          "${precmd[@]}" chmod -R g+rwX,o+X "$dest"/.
          #"${precmd[@]}" find               "$dest"/. -type d -exec chmod g+s '{}' \;
          } 2>/dev/null
          cmderr="${?}"
          if [[ "${cmderr}" -gt 0 ]]; then
              [[ "${precmd[0]}" == 'sudo' ]] && { bfl::error "ERROR: Could not setup to '$dest'"; return 255; } || {
                  precmd=( sudo -p "${fnc}: Need administrator privileges: " )
                  continue
              }
          fi
          break
      done

      printf "${fnc}: %s\n" "Status of involved directories."
      ls -ld "$dest"/. "$dest"/*

      printf "${fnc}: %s\n" "Install Homebrew."
      ruby -e "$(curl -fL 'https://raw.githubusercontent.com/Homebrew/install/master/install')"
#        curl -L https://github.com/Homebrew/homebrew/tarball/master |
#            tar xz --strip 1 -C "${prefix}"

#        printf "${fnc}: %s\n" "Create symlink for { brew }."
#        ln -vnfs "${prefix}/bin/brew" "$dest"/bin/brew
#
#        printf "${fnc}: %s\n" "Update Homebrew."
#        "$dest"/bin/brew update

      umask "${umask_bak}"
  } 1>&2

  }