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
# Defines function: bfl::bash_command_list().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Display list of commands and where they are defined.
#   If called as *_overrides or with --overrides, only show those defined multiple times.
#   Includes BASH Alias/Keyword/Function/Builtin entries.
#
# @param String $path
#   Directory to make backup.
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::bash_command_list '/usr/local'
#------------------------------------------------------------------------------
bfl::bash_command_overrides () { bfl::bash_command_list --overrides "$@"; }

bfl::bash_command_list() {
  # Verify dependencies.
  bfl::verify_dependencies 'compgen' 'sort' 'type' || return $?

  # List of local strings.
  local vars_sl_=(
      fnc                     # Function name.
      tmp                     # General temporary variable.
      arg                     # Argument for parsing.

      # TERM chars for regex/delim use.
      tc_spc tc_tab tc_nln    # Space, Tab, Newline
      tc_tilde tc_fslash      # Tilde, Forward-slash

      # Values for IFS assignment.
      IFS_DEF                 # Default IFS
      IFS_TAN                 # Break on Tab/Newline
      IFS_NLN                 # Break only on Newline
      IFS_RGX                 # Glob using pipe '|'

      typ dir cmd file
      )

  # List of exported local strings.
  local vars_slx=( IFS )
  # List of local arrays.
  local vars_al_=(
      args                    # Arguments to function.
      typs dirs cmds cmd_typs
      )
  # List of local integers.
  local vars_il_=(
      fnc_return
      I J K
      flg_overrides           # Ran in list-overrides mode?
      )

  # List of all local variables.
  local vars
  vars=( ${vars_sl_[*]} ${vars_slx[*]} ${vars_al_[*]} ${vars_il_[*]} )
  # Declare variables.
  local    ${vars_sl_[*]}
  local -x ${vars_slx[*]}
  local -a ${vars_al_[*]}
  local -i ${vars_il_[*]}

  fnc="${FUNCNAME[0]}"    # This function.
  fnc_return=0            # Return code for this function.

  # Assign various delimiters for IO
  printf -v tc_spc    ' '
  printf -v tc_tab    '\t'
  printf -v tc_nln    '\n'
  printf -v tc_tilde  '~'
  printf -v tc_fslash '/'
  printf -v IFS_DEF   ' \t\n'
  printf -v IFS_TAN   '\t\t\n'
  printf -v IFS_NLN   '\n\n\n'
  printf -v IFS_RGX   '|\t\n'
  IFS="${IFS_DEF}"

  flg_overrides=0
  args=( "${@}" )
  for (( I=0; I<"${#args[@]}"; I++ )); do
      [[ "${args[${I}]}" == --* ]] || continue
      case "${args[${I}]:2}" in
      ( overrides )       flg_overrides=1;;
      esac
      unset args[${I}]
  done

  args=( "${args[@]}" )

  # Default types of commands for BASH.
  typs=( alias keyword function builtin file )
  IFS="${IFS_NLN}"                  # Break on newline only.
  dirs=( ${PATH//:/${tc_nln}} )     # Array of command paths.

  # Use completion capability to generate list of commands.
  cmds=( $( compgen -A command "${args[@]}" | sort -u ) )

  IFS="${IFS_DEF}"                  # Reset IFS to default.

  # For each command found ..
  for cmd in "${cmds[@]}"; do

      # .. find all known types.
      cmd_typs=( $( type -at "${cmd}" ) )

      # This function is only concerned with overrides ( i.e. duplicates )
      [ "${#cmd_typs[@]}" -gt 1 -o "${flg_overrides}" -eq 0 ] || continue

      printf %s "${cmd}"            # Show what command we're looking at.

      for typ in "${typs[@]}"; do
          # For all types other than 'file', simply show that any entry was found ..
          [[ "${typ}" == "file" ]] || {
              [[ "${cmd_typs[*]}" =~ ^(.* )?${typ}( .*)?$ ]] && printf '\t%s' "${typ}"
              continue # .. then continue to the next entry.
              }
          # Once we find 'file' types, move on to the next stage.
          break
      done

      # If the last type found was 'file', then let's find them.
      [[ "${typ}" == "file" ]] && {

          # For each directory in our PATH ..
          for dir in "${dirs[@]}"; do
              file="${dir}/${cmd}"

              # .. show any entry for the current command.
              # ( further, if in home-dir, shorten/anonymize the entry. )
              [ -d "${file}" -o ! -r "${file}" -o ! -x "${file}" ] \
                  || printf '\t%s' "${dir/#${HOME}${tc_fslash}/${tc_tilde}${tc_fslash}}"
          done
      }

      printf '\n'   # New is always better! ;P
  done

  return "${fnc_return:-0}"
  }