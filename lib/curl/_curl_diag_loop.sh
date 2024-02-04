#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to cUrl
#
# @author  A. River
#
# @file
# Defines function: bfl::curl_diag_loop().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Run a diagnostic loop using provided curl arguments.
#
# @param Integer $count
#   First argument must be number of loop iterations to run.
#
# @param String $curl_args
#   curl arguments. Remainder of arguments can be pretty much anything you would otherwise provide to curl.
#   Also accepts input on STDIN, which will be provided to each iteration.
#
# @example
#   bfl::curl_diag_loop 5 ...
#------------------------------------------------------------------------------
bfl::curl_diag_loop() {
  # Verify arguments count.
  (( $# > 0 && $# < 1000 )) || { bfl::error "arguments count $# ∉ [1..999]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify argument values.
  bfl::is_blank "$1" && { bfl::error "Argument 1 (loop iterations count) is blank."; return ${BFL_ErrCode_Not_verified_arg_values}; }

  # Verify dependencies.
  bfl::verify_dependencies 'curl' || return $?

  # Declare local variables.
  declare vars=(
      tc_spc tc_tab tc_nln    # Delimiters
      IFS IFS_IN IFS_OUT      # Needed to affect how input/output works
      cnt_fmt_min             # Loop count and minimum length of count formatting
      flds                    # Definitions of fields/headers/formatting
      hdrs fmts               # Lists of headers and formats
      fld hdr fmt             # Individual entities for field/header/format
      curl_base               # Curl command starting point
      curl_args               # Curl arguments provided at CLI
      curl_data               # Curl input data, if provided, from STDIN
      curl_wout               # Curl Write-Out argument
      curl_cmd                # Curl command, including all options/arguments
      curl_out                # Curl output
      )
  declare ${vars[*]}

  # Delimiters
  printf -v tc_spc ' '
  printf -v tc_tab '\t'
  printf -v tc_nln '\n'

  # Break input only on TAB or Newline chars.
  printf -v IFS_IN  '%s%s%s' "${tc_tab}" "${tc_tab}" "${tc_nln}"
  # Standard IFS for output; Specifically, glob quoted array with Space char delimiter.
  printf -v IFS_OUT '%s%s%s' "${tc_spc}" "${tc_tab}" "${tc_nln}"

  # If STDIN is not terminal, then pull in possible data for curl.
  [ -t 0 ] || curl_data="$( cat - )"

  local -i cnt="$1"
  shift
  curl_args=( "${@}" )

  # Set minimum count format length.
  # This is a cheat to help with formatting later on.
  printf -v cnt_fmt_min '%*s' $( (( cnt>999 )) && echo "${#cnt}" || echo "3" )

  # Starting point of curl command.
  curl_base=(
      curl
      -s
      -o /dev/null
      )

  # List of Field/Header/Field-Format/Header-Format
  # Field is required.
  # Header defaults to be equal to field.
  # If Field-format is to be defined, then header must be defined ( or at least empty ).
  # Header-format is needed if field-format is numerical ( not %s ).
  flds=(
        http_code:h_code:%6s
        http_connect:h_con:%6s
        num_connects:#_cons:%6s
        num_redirects:#_rdrs:%6s
        size_header:s_hdr:%6s
        size_upload:s_up:%6s
        speed_upload:%_up:%8.1f:%8s
        size_request:s_req:%6s
        size_download:s_down:%6s
        speed_download:%_down:%9.1f:%9s
        time_namelookup:t_name:%6s
        time_appconnect:t_acon:%6s
        time_connect:t_con:%6s
        time_redirect:t_rdr:%6s
        time_pretransfer:t_ptrn:%6s
        time_starttransfer:t_strn:%6s
        time_total:t_tot:%6s
        ssl_verify_result:ssl:%4s
        local_ip:l_ip:%15s
        local_port:l_prt:%5s
        remote_ip:r_ip:%15s
        remote_port:r_prt:%5s
        content_type:typ:%s
        #filename_effective:fname:"\\n${cnt_fmt_min} %s"
        #url_effective:url_eff:"\\n${cnt_fmt_min} %s"
        #redirect_url:rdr_url:"\\n${cnt_fmt_min} %s"
        #ftp_entry_path:ftp_ep:"\\n${cnt_fmt_min} %s"
      )

  hdrs=( "cnt" )  # Initialize headers and formats with count.
  fmts=( "%0${#cnt_fmt_min}d:%${#cnt_fmt_min}s" )

    # Generate lists of headers and formats, as well as write-out arg for curl.
  local -i i=0
  for (( i=0; i<${#flds[@]}; i++ )); do
      fld="${flds[$i]%%:*}"                   # Field is very first entry in colon-delimited string.
      hdr="${flds[$i]#*:}"                    # Header is next in string.
      fmt="${hdr#*:}"                         # Obtain format[s] from end of header string.
      hdr="${hdr%%:*}"                        # Now truncate header string to just he header name.
      [[ "${hdr}" == "${fmt}" ]] && fmt='%s'  # If header and format are equal, this means format was not defined.
      [[ -n "${hdr}" ]] || hdr="${fld}"       # If header is null, then set equal to field name.
      # Add header and format[s] to lists.
      hdrs=( "${hdrs[@]}" "${hdr}" )
      fmts=( "${fmts[@]}" "${fmt}" )
      # Append write-out entry to write-out arg.
      curl_wout="${curl_wout:+${curl_wout}\t}%{${fld}}"
    done

    # Set output globbing to space-delimited.
    IFS="${IFS_OUT}"

    # Print headers.
    printf "${fmts[*]#*:}\n" "${hdrs[@]}"

    ## Print formats ( for debugging ).
    #printf "${fmts[*]#*:}\n" "${fmts[@]//%}"

    # Generate curl command.
    # Write-out argument is last, so it takes precedence over write-out provided on CLI
    curl_cmd=(
        "${curl_base[@]}"
        "${curl_args[@]}"
        -w
        "${curl_wout}"
    )

    # Iterate over number of loops requested.
    for (( i=1; i<=cnt; i++ )); do
        # Set input breakpoints as TAB or Newline.
        IFS="${IFS_IN}"
        # Capture curl output of write-out data.
        curl_out=( $( printf %s "${curl_data}" | "${curl_cmd[@]}" ) )
        # Space-delimited output globbing.
        IFS="${IFS_OUT}"
        # Print curl write-out results.
        printf "${fmts[*]%:*}\n" "$i" "${curl_out[@]}"
    done
  }