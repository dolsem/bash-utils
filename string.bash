###########################################################################
# Script Name	: string.bash
# Requires    : os.bash
# Description	: Bash functions for string manipulation.
# Author      : Denis Semenenko
# Email       : dols3m@gmail.com
# Date written: September 2018
#
# Distributed under MIT license
# Copyright (c) 2019 Denis Semenenko
###########################################################################

if [[ $DOLSEM_SHELL_COLLECTION_HELPERS_STRING == true ]]; then return; fi
DOLSEM_SHELL_COLLECTION_HELPERS_STRING=true

source $(dirname $0)/os.bash

strip_whitespace() {
  regexp="((\S+\s+)*\S+)"
  if is_macos; then
    echo $1 | perl -nle"if (m{$regexp}g) { print \$1; }"
  else
    echo $1 | grep -oP $regexp
  fi
}

escape_fslash() {
  sed 's_/_\\/_g' <<< $1
}
