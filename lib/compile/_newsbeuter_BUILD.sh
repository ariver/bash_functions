#!/usr/bin/env bash
# Prevent this file from being sourced more than once
[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of useful utility functions for compiling sources
#
# @author  A. River
#
# @file
# Defines function: bfl::newsbeuter_build().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ............................
#
# @example
#   bfl::newsbeuter_build
#------------------------------------------------------------------------------
bfl::newsbeuter_BUILD() { bfl::newsbeuter_build "$@"; return $?; } # for compability with Ariver' repository

bfl::newsbeuter_build() {
#  bfl::verify_arg_count "$#" 0 0 || { bfl::writelog_fail "${FUNCNAME[0]} arguments count $# ≠ 0"; return ${BFL_ErrCode_Not_verified_args_count}; }     # Verify argument count.

  # Verify argument values.
#  bfl::is_blank "$1" && { bfl::writelog_fail "${FUNCNAME[0]}: empty string."; return ${BFL_ErrCode_Not_verified_arg_values}; }

  local {PKGS,TMPS,NLN,TAB,I}=
  declare -x PATH="${PATH}"
  declare -x PKG_CONFIG_PATH LDFLAGS CPPFLAGS CPATH

  printf -v TAB "\t"
  printf -v NLN "\n"

  PATH="$(
        echo "${PATH//:/${NLN}}" |
            nl -b a -n rz -s : -w 6 -v 100001 |
            sed "\=:/usr/local/Cellar/=d;\=:${HOME}/=d;\=:/opt/=d;\=:/usr/local/s*bin\$=s=^1=0=" |
            sort -t: -k 1,1g |
            cut -d: -f2- |
            paste -sd: -
  )"

  PATH="${PATH}:$(
        brew ls $( brew ls ) |
            egrep "/s?bin/($(
                diff \
                    <( for I in $( compgen -A command ); do type -ap "${I}"; done | egrep -v "^/(s?bin|usr/s?bin)/" | sed "s=.*/==" | sort -u ) \
                    <( brew ls $( brew ls ) | sed -n "s=^/.*/s*bin/\([^/]*\)\$=\1=p" | sort -u ) |
                sed -n "s/^> //p" | paste -sd"|" -
            ))\$" |
            sed -n "s=^\(/.*/s*bin\)/.*=\1=p" |
            sort -u |
            paste -sd: -
  )"

  PKG_CONFIG_PATH="$( pkg-config --variable pc_path pkg-config )";
  PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:$(
        brew ls $( brew ls ) |
            egrep "/pkgconfig/($(
                diff \
                    <( find ${PKG_CONFIG_PATH//:/ } -maxdepth 1 -name "*.pc" 2>/dev/null | sed -n "s=.*/pkgconfig/\([^/]*\)\.pc\$=\1=p" | sort -u ) \
                    <( brew ls $( brew ls ) | sed -n "s=.*/pkgconfig/\([^/]*\)\.pc\$=\1=p" | sort -u ) |
                sed -n "s/^> //p" |
                paste -sd"|" -
            ))\.pc\$" |
            sed -n "s=^\(/.*/pkgconfig\)/[^/]*\.pc\$=\1=p" |
            paste -sd: -
  )"

  local arr
  arr=$(
        for I in "${PKGS[@]}"; do
            echo "${I}"
            brew deps -n --union "${I}" $( brew options --compact "${I}" )
        done | sort -u )

  PKGS=( newsbeuter curl )
  TMPS=(
        $(
            for I in ${arr[@]}; do
                brew ls "$I"
            done |
            sed -E -n "s=^(/.*/(lib|include))/.*=\1=p" | sort -u
        )
    )

  LDFLAGS="$(  printf "%s\n" "${TMPS[@]}" | sed -n "s=^.*/lib\$=-L&=p"     | paste -sd" " - )"
  CPPFLAGS="$( printf "%s\n" "${TMPS[@]}" | sed -n "s=^.*/include\$=-I&=p" | paste -sd" " - )"
  CPATH="$(    printf "%s\n" "${TMPS[@]}" | sed -n "s=^.*/include\$=&=p"   | paste -sd: - )"

  for I in PATH {,PKG_CONFIG_,C}PATH {LD,CPP}FLAGS; do
      eval "printf \"\\\n${I}=\\\n\\\t%s\\\n\" \"\${${I}//:/\${NLN}${TAB}}\""
  done

  printf "\nMAKE\n"
  make prefix=~/.local

  printf "\nINSTALL\n"
  make prefix=~/.local install
  }