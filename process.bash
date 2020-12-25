###########################################################################
# Script Name	: process.bash
# Description	: Bash functions related to process execution.
# Author      : Denis Semenenko
# Email       : dols3m@gmail.com
# Date written: December 2020
#
# Distributed under MIT license
# Copyright (c) 2020 Denis Semenenko
###########################################################################

if [[ $DOLSEM_SHELL_COLLECTION_HELPERS_PROCESS == true ]]; then return; fi
DOLSEM_SHELL_COLLECTION_HELPERS_PROCESS=true

source $(dirname ${BASH_SOURCE[0]:-${(%):-%x}})/assert.bash

#~= Function Name
# push_trap
#~= Description
# Replaces an existing signal trap and assigns the command to restore it
#~= Arguments
# $1 - trap command
# $2 - trap signal
# $3 - name of the variable where to store the restore command
#~= Usage Example
# local pop_trap
# push_trap '{ echo trapped SIGINT; }' SIGINT pop_trap
# eval $pop_trap
push_trap() {
  assert "[[ $# -eq 3 ]]" "${BASH_LINENO[0]}" "push_trap requires a command, a single signal, and a variable name"
  local new_cmd=$1
  local signal=$2
  local push_trap_pop_cmd=$3

  local old_trap=$(trap -p $signal)
  local old_cmd=${old_trap#*\'}
  old_cmd=${old_cmd%\'*}

  trap "exitcode=\$?;(exit \$exitcode);${new_cmd};(exit \$exitcode);${old_cmd:-exit \$exitcode}" $signal
  eval $push_trap_pop_cmd="\"${old_trap:-trap - $signal}\""
}
