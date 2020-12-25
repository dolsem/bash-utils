###########################################################################
# Script Name	: prompt.bash
# Description	: Bash functions for getting user input.
# Author      : Denis Semenenko
# Email       : dols3m@gmail.com
# Date written: September 2018
#
# Distributed under MIT license
# Copyright (c) 2019 Denis Semenenko
###########################################################################

if [[ $DOLSEM_SHELL_COLLECTION_HELPERS_PROMPT == true ]]; then return; fi
DOLSEM_SHELL_COLLECTION_HELPERS_PROMPT=true

source $(dirname ${BASH_SOURCE[0]:-${(%):-%x}})/filesystem.bash
source $(dirname ${BASH_SOURCE[0]:-${(%):-%x}})/assert.bash
source $(dirname ${BASH_SOURCE[0]:-${(%):-%x}})/process.bash

if [[ -n $ZSH_VERSION ]]; then
  setopt shwordsplit
else
  shopt -s expand_aliases
fi

#------< Helpers >------#
if [[ -n $ZSH_VERSION ]]; then
  alias read_n='read -k'
  ENTER_KEY=$'\xa'
  START_IX=1
else
  alias read_n='read -n'
  ENTER_KEY=''
  START_IX=0
fi

cursor_blink_on()   { printf "\033[?25h"; }
cursor_blink_off()  { printf "\033[?25l"; }
cursor_to()         { printf "\033[$1;${2:-1}H"; }

get_cursor_row()    { echo -ne $'\e[6n' > /dev/tty; read_n 2 -rs; read -sdR; echo ${REPLY%;*}; }

read_key()          {
  local key
  IFS= read_n 1 -rs key 2>/dev/null >&2
  if [[ $key == $ENTER_KEY ]]; then echo enter; fi;
  if [[ $key == $'\x20'    ]]; then echo space; fi;
  if [[ $key == $'\x1b'    ]]; then
    read_n 2 -rs key
    if [[ $key == '[A' ]]; then echo up;    fi;
    if [[ $key == '[B' ]]; then echo down;  fi;
  fi
}

#------< Prompt functions >------#

#~= Function Name
# prompt_for_enter
#~= Description
# Wait for user to press Enter
#~= Arguments
# [$@] - prompt string to print
prompt_for_enter() {
  if [[ -n $1 ]]; then printf "$@"; fi

  local tty_settings=$(stty -g)
  local pop_trap
  push_trap "stty '$tty_settings'" INT pop_trap

  stty -echo
  until [[ `read_key` == enter ]]; do :; done
  stty "$tty_settings"

  eval $pop_trap
}

#~= Function Name
# prompt_with_default
#~= Description
# Prompt for user input showing default value
#~= Arguments
#  $1  - name of variable containing default string, where result value will be stored
# [$2] - message to be displayed before prompt
prompt_with_default() {
  assert "[[ -n '${1+x}' ]]" "${BASH_LINENO[0]}" "prompt_with_default takes at least one argument"
  local retvar=$1
  local message=$2

  if command -v vared &>/dev/null; then   # Zsh
    vared -p "$message" -c $retvar
  else                                    # Bash
    eval 'local default=$'$retvar''
    read -e -p "${message}" -i "$default" $retvar
  fi
}

#~= Function Name
# prompt_for_bool
#~= Description
# Prompt for yes/no answer
#~= Arguments
#  $1  - name of variable where result value (true/false) will be stored
# [$2] - message to be displayed before prompt
prompt_for_bool() {
  assert "[[ -n '${1+x}' ]]" "${BASH_LINENO[0]}" "prompt_for_bool takes at least one argument"
  local retvar=$1
  local message=$2
  declare result

  echo -n "${message} (y/n): "
  while [ -z ${result:+x} ]; do
    read_n 1 -s response
    if [[ $response =~ [yY] ]]; then
      result=true
    elif [[ $response =~ [nN] ]]; then
      result=false
    fi
  done
  echo $response
  eval $retvar="'$result'"
}

#~= Function Name
# prompt_for_file
#~= Description
# Prompt for path to existing file
#~= Arguments
#  $1  - name of variable where result path will be stored
# [$2] - message to be displayed before prompt
# [$3] - custom error message
#~= Usage Example
# prompt_for_file file_path 'Please enter path to file' 'File {path} not found'
prompt_for_file() {
  assert "[[ -n '${1+x}' ]]" "${BASH_LINENO[0]}" "prompt_for_file takes at least one argument"
  local retvar=$1
  local message=$2
  local error_message=$3
  declare __path

  if [ -z "$message" ]; then
    message='Enter path to file'
  fi
  if [ -z "$error_message" ]; then
    error_message='File {path} does not exist.'
  fi

  while true; do
    if command -v vared &>/dev/null; then   # Zsh
      vared -p "${message}: " -c __path
    else                                    # Bash
      read -e -p "${message}: " __path
    fi

    if [ -z "$__path" ]; then
      echo -ne '\033[1A'
      continue
    fi
    if [ -f "$__path" ]; then
      break
    else
      echo ${error_message//\{path\}/$__path}
    fi
  done

  eval $retvar="'$(abspath "$__path")'"
}

# Based on https://unix.stackexchange.com/a/415155
#~= Function Name
# prompt_for_option
#~= Description
# Prompt user to select an option from menu with arrow keys
#~= Arguments
# $N - Nth option name
#~= Returns
# Selected option index
#~= Usage Example
# prompt_for_option 'Option A' 'Option B' 'Option C'
prompt_for_option() {
  print_option()      { printf "   $1 "; }
  print_selected()    { printf "  \033[7m $1 \033[27m"; }

  # initially print empty new lines (scroll down if at bottom of screen)
  for opt; do printf "\n"; done

  # determine current screen position for overwriting the options
  local lastrow=`get_cursor_row`
  local startrow=$(($lastrow - $#))

  # ensure cursor and input echoing back on upon a ctrl+c during read -s
  trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
  cursor_blink_off

  local selected=0
  while true; do
    # print options by overwriting the last lines
    local idx=0
    for opt; do
      cursor_to $(($startrow + $idx))
      if [ $idx -eq $selected ]; then
          print_selected "$opt"
      else
          print_option "$opt"
      fi
      ((idx++))
    done

    # respond to pressed key
    case `read_key` in
      enter|space)  break;;
      up)           ((selected--));
                    if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
      down)         ((selected++));
                    if [ $selected -ge $# ]; then selected=0; fi;;
    esac
  done

  # cursor position back to normal
  cursor_to $lastrow
  cursor_blink_on

  return $selected
}

#~= Function Name
# prompt_for_multiselect
#~= Description
# Prompt user to select multiple options from menu (Space to select, Enter to submit)
#~= Arguments
# $1 - name of variable where result array will be stored
# $2 - list of options, separated by semicolon
# $3 - list of default options, separated by semicolon
#~= Usage Example
# prompt_for_multiselect result 'Option A;Option B;Option C' ';true;true'
# echo ${result[2]}      # Will output 'true' if option C was selected
prompt_for_multiselect() {
  print_inactive()    { printf "$2   $1 "; }
  print_active()      { printf "$2  \033[7m $1 \033[27m"; }
  toggle_option()    {
    local arr_name=$1
    eval "local arr=(\"\${${arr_name}[@]}\")"
    local option=$2
    if [[ ${arr[option]} == true ]]; then
      arr[option]=
    else
      arr[option]=true
    fi
    eval $arr_name='("${arr[@]}")'
  }

  local retval=$1
  declare options
  declare defaults
  IFS=';' options=($2) IFS=$' \t\n'
  IFS=';' defaults=($3) IFS=$' \t\n'
  local selected=()

  for ((i=0; i<${#options[@]}; i++)); do
    selected+=("${defaults[i+START_IX]}")
    printf "\n"
  done

  # determine current screen position for overwriting the options
  local lastrow=`get_cursor_row`
  local startrow=$(($lastrow - ${#options[@]}))

  # ensure cursor and input echoing back on upon a ctrl+c during read -s
  trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
  cursor_blink_off

  local active=0
  while true; do
    # print options by overwriting the last lines
    local idx=0
    for option in "${options[@]}"; do
      local prefix="[ ]"
      if [[ ${selected[idx+START_IX]} == true ]]; then
        prefix="[x]"
      fi

      cursor_to $(($startrow + $idx))
      if [ $idx -eq $active ]; then
        print_active "$option" "$prefix"
      else
        print_inactive "$option" "$prefix"
      fi
      ((idx++))
      done

      # respond to pressed key
      case `read_key` in
        space)  toggle_option selected $((active + START_IX));;
        enter)  break;;
        up)     ((active--));
                if [ $active -lt 0 ]; then active=$((${#options[@]} - 1)); fi;;
        down)   ((active++));
                #echo "$active ${#options[@]}"
                if [ $active -ge ${#options[@]} ]; then active=0; fi;;
      esac
  done

  # cursor position back to normal
  cursor_to $lastrow
  printf "\n"
  cursor_blink_on

  eval $retval='("${selected[@]}")'
}
