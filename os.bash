###########################################################################
# Script Name	: os.bash
# Description	: OS-related Bash functions.
# Author      : Denis Semenenko
# Email       : dols3m@gmail.com
# Date written: September 2018
#
# Distributed under MIT license
# Copyright (c) 2019 Denis Semenenko
###########################################################################

if [[ $DOLSEM_SHELL_COLLECTION_HELPERS_OS == true ]]; then return; fi
DOLSEM_SHELL_COLLECTION_HELPERS_OS=true

is_macos() {
  [[ "$(uname)" == "Darwin" ]]
}

