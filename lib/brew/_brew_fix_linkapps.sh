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
# Defines function: bfl::brew_fix_linkapps().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ..............................
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::brew_fix_linkapps
#------------------------------------------------------------------------------
bfl::brew_fix_linkapps() {
  # Verify dependencies.
  bfl::verify_dependencies 'brew' 'sed' || return $?

  local {IFS,apps,app,applnk,lnk,str}=
  printf -v IFS '\t'
  [[ $BASH_INTERACTIVE == true ]] && printf '\n# Generating Apps List and Updating Links ..\n'
  str=$(brew linkapps 2>&1 | grep -o '[^/]*\.app' | sort -u | tr '\n' '\t' )
  apps=($str)
  printf -v IFS ' \t\n'
  apps=("${apps[@]/#//Applications/}")
  [[ $BASH_INTERACTIVE == true ]] && printf '\n'
  for app in "${apps[@]}"; do
      [[ -z "${app}" ]] || ! [[ -e "${app}" ]] || {
          [[ $BASH_INTERACTIVE == true ]] && printf '# Removing .. %s\n' "${app}"
          rm -i -rf "${app}"
          }
  done

  [[ $BASH_INTERACTIVE == true ]] && printf '\n# Generating Apps Links ..\n'
  brew linkapps
  for app in "${apps[@]}"; do
      applnk="${app}.linkapps_fix"
      [[ $BASH_INTERACTIVE == true ]] && printf '\n# Moving link .. %s\n' "${applnk}"
      rm -i -f "${applnk}"
      mv -i -vf "${app}" "${applnk}"
      lnk="$( ls -lond "${applnk}" | sed -n 's=.* -> ==p' )"
      [[ $BASH_INTERACTIVE == true ]] && printf '# Generating Fixed Links .. %s .. %s\n' "${app}" "${lnk}"
      mkdir -p "${app}"
      ln -vnfs "${lnk}"/* "${app}"/
      chmod -R a+rx "${app}"
      [[ $BASH_INTERACTIVE == true ]] && printf '# Removing .. %s\n' "${applnk}"
      rm -i -vf "${applnk}"
  done
  }