###########################################################################
# Script Name	: array.bash
# Requires    : assert.bash
# Description	: Bash functions for array manipulation.
# Author      : Denis Semenenko
# Email       : dols3m@gmail.com
# Date written: March 2020
#
# Distributed under MIT license
# Copyright (c) 2020 Denis Semenenko
###########################################################################

if [[ $DOLSEM_SHELL_COLLECTION_HELPERS_ARRAY == true ]]; then return; fi
DOLSEM_SHELL_COLLECTION_HELPERS_ARRAY=true

source $(dirname ${BASH_SOURCE[0]:-${(%):-%x}})/assert.bash

#~= Function Name
# array_contains_value
#~= Description
# Checks if array has a specified value
#~= Arguments
# $1     - name of the variable where the array is stored
# ${@:2} - values to search for
#~= Usage Example
# array_contains_value fruits apple
array_contains_value() {
  local array_item array_values="${1}[@]"
  for array_item in "${!array_values}"; do
    for value in "${@:2}"; do
      if [[ "$array_item" == "$value" ]]; then return 0; fi
    done
  done
  return 1
}

#~= Function Name
# array_remove_value
#~= Description
# Removes all matching elements from array
#~= Arguments
# $1     - name of the variable where the array is stored
# ${@:2} - values to remove
#~= Usage Example
# array_remove_value args -a
array_remove_value() {
  assert "[[ -n '${2+x}' ]]" "${BASH_LINENO[0]}" "array_remove_value takes two arguments"
  local array=$1 values=("${@:2}")

  local v new_array array_values="${array}[@]" retval=1
  for v in "${!array_values}"; do
    if ! array_contains_value values $v; then
      new_array+=( "$v" )
    else
      retval=0
    fi
  done

  eval $array="( ${new_array[@]} )"
  return $retval
}