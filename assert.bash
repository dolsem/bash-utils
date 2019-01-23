###########################################################################
# Script Name	: assert.bash
# Description	: Contains assert implementation.
# Author      : Denis Semenenko
# Email       : dols3m@gmail.com
# Date written: January 2019
#
# Distributed under MIT license
# Copyright (c) 2019 Denis Semenenko
###########################################################################

export DOLSEM_SHELL_COLLECTION_HELPERS_ASSERT=true

#~= Function Name
# assert
#~= Description
# Exit script with error if condition is not met
#~= Arguments
#  $1  - Condition
# [$2] - Line number, function name or region where assertion is made (Bash-only)
# [$3] - Custom error message
# [$4] - Command to be called with error code
#~= Usage Example
# assert "[[ $a -lt $b ]]" $LINENO 'a must be less than b' return
assert() {
  if [[ -z ${1+x} ]]; then
    echo "[assert] Error: Must provide assert condition."
    $exit_cmd 98
  fi
  local cond=$1

  local result=$(eval "if $cond; then echo true; else echo false; fi")
  if [[ $result == false ]]; then

    if [[ -z $functrace ]]; then
      if [[ -n ${2+x} ]]; then
        local origin="($0:$2)"
      fi
    fi

    if [[ -n ${3+x} ]]; then
      local message=$3
    else
      local message="'$cond' failed."
    fi

    if [[ -n ${4+x} ]]; then
      local exit_cmd=$4
    else
      local exit_cmd=exit
    fi

    printf "[assert] Assertion Error: $message "
    if [[ -n $origin ]]; then
      printf $origin
    fi
    if [[ -n $functrace ]]; then
      printf "\nStack trace:\n"
      printf '  %s\n' $functrace
    else
      echo
    fi

    $exit_cmd 99
  fi
}
