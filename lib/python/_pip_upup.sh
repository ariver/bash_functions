#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to Python
#
# @author  A. River
#
# @file
# Defines function: bfl::pip_upup().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Guided python update
#
# @example
#   bfl::pip_upup
#------------------------------------------------------------------------------

# for compability with Ariver' repository
function pip_pypy_upup()  { bfl::pip_upup "${@}"; return $?; }
function pip_pypy3_upup() { bfl::pip_upup "${@}"; return $?; }
function pip3_upup()      { bfl::pip_upup "${@}"; return $?; }

bfl::pip_pypy_upup()  { bfl::pip_upup "${@}"; return $?; }
bfl::pip_pypy3_upup() { bfl::pip_upup "${@}"; return $?; }
bfl::pip3_upup()      { bfl::pip_upup "${@}"; return $?; }

bfl::pip_upup() {

    local IFS fnc pipc pkgs pkg tmp

    fnc="${FUNCNAME[1]:-${FUNCNAME[0]}}"
    pipc=( ${fnc%_upup} --disable-pip-version-check )
    printf -v IFS   ' \t\n'

    {
        printf -v IFS   '\n'
        pkgs=(
            $(
                "${pipc[@]}" list -o
#                {
#                    { "${pipc[@]}" list -e | grep .; } \
#                        && { "${pipc[@]}" list -o | egrep '^(pip|setuptools) '; } \
#                        || { "${pipc[@]}" list -o; };
#                } 2>/dev/null
            )
        )
        printf -v IFS   ' \t\n'

        if [[ "${#pkgs[@]}" -gt 0 ]]; then

            printf "${fnc}: Proposed Updates..\n"
            printf '  %s\n' "${pkgs[@]}"
            printf "${fnc}: Install Updates? "
            read -p '' tmp

            if [[ "${tmp}" == [Yy]* ]]; then

                printf "${fnc}: Installing Updates\n"
                for pkg in "${pkgs[@]}"; do
                    if [[ "${pkg}" =~ \(Current:.*Latest:.*\) ]]; then
                        printf "\n${fnc}: %s\n" \
                            "Installing ${pkg}"
                        "${pipc[@]}" install -U "${pkg%% *}" 2>&1 |
                            egrep \
                                -e '^Requirement already up-to-date:' \
                                -e '^[[:blank:]]*Using cached' \
                                -e '^[[:blank:]]*Found existing installation:' \
                                -e '^[[:blank:]]*Uninstalling .*:' \
                                -v
                    elif [[ "${pkg}" =~ \(.*,.*\) ]]; then
                        printf '\n%s\n' "${pipc[0]}"' -v list -o 2>&1 | less -isR -p '"${pkg%% *}"
                    else
                        printf "${fnc}: %s\n" \
                            "ERROR: ${pkg}"
                    fi
                done

                printf -v IFS   '\n'
                #pkgs=( $( { "${pipc[@]}" list -e | grep -q . || "${pipc[@]}" list -o; } 2>/dev/null ) )
                pkgs=( $( "${pipc[@]}" list -o ) )
                printf -v IFS   ' \t\n'

                if [[ "${#pkgs[@]}" -gt 0 ]]; then
                    printf "\n${fnc}: Still Outdated\n"
                    printf '  %s\n' "${pkgs[@]}"
                fi
            fi
        else
            printf "${fnc}: No Outdated Packages\n"
        fi
    } 1>&2
  }