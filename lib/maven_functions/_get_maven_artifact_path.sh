#!/usr/bin/env bash

[[ -z $(echo "$BASH_SOURCE" | sed -n '/bash-function-library/p') ]] && return 0 || _bfl_temporary_var=$(echo "$BASH_SOURCE" | sed 's|^.*/lib/\([^/]*\)/\([^/]*\)\.sh$|_GUARD_BFL_\1\2|')
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly $_bfl_temporary_var=1
#------------------------------------------------------------------------------
# ------------ https://github.com/Jarodiv/bash-function-libraries -------------
#
# Library of functions related to the build tool Apache Maven
#
# @author  Michael Strache
#
# @file
# Defines function: bfl::get_maven_artifact_path().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Returns the path the specified maven artefact would have in the local filesystem repository and if that artifact exists on localhost.
#
# @param string $GROUP_ID
#   GroupId as specified in the pom.xml.
#
# @param string $ARTIFACT_ID
#   ArtifactId as specified in the pom.xml.
#
# @param string $VERSION
#   Version of the artefact.
#
# @param string $EXTENSION
#   File extension of the artefact.
#
# @param string $REPOSITORY
#   Path of the local repository, if not located at "${HOME}/.m2/repository".
#
# @return String $result
#   Artifact path.
#
# @example
#   bfl::get_maven_artifact_path ....
#------------------------------------------------------------------------------
#
bfl::get_maven_artifact_path() {
  bfl::verify_arg_count "$#" 1 1 || exit 1  # Verify argument count.

  local -r GROUP_ID="${1:-}"
  local -r ARTIFACT_ID="${2:-}"
  local -r VERSION="${3:-}"
  local -r EXTENSION="${4:-}"
  local -r REPOSITORY="${5:-$HOME/.m2/repository}"

  local -r ARTIFACT="$REPOSITORY/${GROUP_ID//./\/}/$ARTIFACT_ID/$VERSION/${ARTIFACT_ID}-${VERSION}.$EXTENSION"

  echo "$ARTIFACT"
  [[ -f "$ARTIFACT" ]]
  }