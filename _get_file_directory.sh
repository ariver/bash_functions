#!/usr/bin/env bash

#------------------------------------------------------------------------------
# @file
# Defines function: bfl::get_file_directory().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Gets the canonical path to the directory in which a file resides.
#
# @param string $path
#   A relative path, absolute path, or symlink.
#
# @return string $canonical_directory_path
#   The canonical path to the directory in which a file resides.
#------------------------------------------------------------------------------
bfl::get_file_directory() {
  bfl::validate_arg_count "$#" 1 1 || exit 1

  declare -r path="$1"
  declare canonical_directory_path
  declare canonical_file_path

  if bfl::is_empty "${path}"; then
    bfl::die "Error: the path was not specified."
  fi

  canonical_file_path=$(bfl::get_file_path "${path}") || bfl::die
  canonical_directory_path=$(dirname "${canonical_file_path}}") || bfl::die

  printf "%s" "${canonical_directory_path}"
}
