#!/usr/bin/env bash

[[ -z $(echo "$BASH_SOURCE" | sed -n '/bash_functions_library/p') ]] && return 0 || _bfl_temporary_var=$(echo "$BASH_SOURCE" | sed 's|^.*/lib/\([^/]*\)/\([^/]*\)\.sh$|_GUARD_BFL_\1\2|')
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly $_bfl_temporary_var=1
#------------------------------------------------------------------------------
# ------------ https://github.com/Jarodiv/bash-function-libraries -------------
#
# Library of functions related to the software repository manager Sonatype Nexus
#
# @author  Michael Strache
#
# @file
# Defines function: bfl::get_nexus_artifact_url().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Make string of an Nexus artifact.
#
# @param String   SERVER
#
# @param String   REPOSITORY
#
# @param String   GROUP
#
# @param String   ARTIFACT
#
# @param String   VERSION
#
# @param String   EXTENSION
#
# @return String $result
#   Artifact url.
#
# @example
#   bfl::get_nexus_artifact_url ....
#------------------------------------------------------------------------------
#
bfl::get_nexus_artifact_url() {
  bfl::verify_arg_count "$#" 6 6 || exit 1  # Verify argument count.

  local -r SERVER="${1:-}"
  local -r REPOSITORY="${2:-}"
  local -r GROUP="${3:-}"
  local -r ARTIFACT="${4:-}"
  local -r VERSION="${5:-}"
  local -r EXTENSION="${6:-}"

  echo "$SERVER/nexus/service/local/artifact/maven/redirect?r=${REPOSITORY}&g=${GROUP}&a=${ARTIFACT}&v=${VERSION}&e=${EXTENSION}"
  }