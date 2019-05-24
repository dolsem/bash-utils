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

#~= Function Name
# install_pkg
#~= Description
# Install package using appropriate system package manager
#~= Arguments
#  $1  - package name on Mac OS
# [$2] - package name on Debian (equal to Mac OS package name by default)
install_pkg() {
  local mac_package_name=$1
  local apt_package_name=${2:-$mac_package_name}

  if is_macos; then
    if ! command -v brew 1>/dev/null 2>&1; then
      echo "Error: Homebrew is not installed. Please install by visiting https://brew.sh"
      return 1
    fi

    if brew ls --versions $mac_package_name >/dev/null; then
      return 0
    fi

    brew install $mac_package_name
  else
    if ! command -v apt-get 1>/dev/null 2>&1; then
      echo "Error: Your system's package manager is not supported"
      return 1
    fi

    if apt-cache policy $apt_package_name | head -2 | tail -1 | grep -v 'Installed: (none)' >/dev/null; then
      return 0
    fi

    sudo apt-get -y install $apt_package_name
  fi

  return $?
}