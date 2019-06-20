###########################################################################
# Script Name	: term.bash
# Description	: Terminal-related Bash functions.
# Author      : Denis Semenenko
# Email       : dols3m@gmail.com
# Date written: September 2018
#
# Distributed under MIT license
# Copyright (c) 2019 Denis Semenenko
###########################################################################

if [[ $DOLSEM_SHELL_COLLECTION_HELPERS_TERM == true ]]; then return; fi
DOLSEM_SHELL_COLLECTION_HELPERS_TERM=true

red() { tput -T${TERM:-dumb} setaf 1; cat; tput -T${TERM:-dumb} sgr0; }
green() { tput -T${TERM:-dumb} setaf 2; cat; tput -T${TERM:-dumb} sgr0; }
yellow() { tput -T${TERM:-dumb} setaf 3; cat; tput -T${TERM:-dumb} sgr0; }
blue() { tput -T${TERM:-dumb} setaf 4; cat; tput -T${TERM:-dumb} sgr0; }
magenta() { tput -T${TERM:-dumb} setaf 5; cat; tput -T${TERM:-dumb} sgr0; }
cyan() { tput -T${TERM:-dumb} setaf 6; cat; tput -T${TERM:-dumb} sgr0; }
white() { tput -T${TERM:-dumb} setaf 7; cat; tput -T${TERM:-dumb} sgr0; }
dim() { tput -T${TERM:-dumb} dim; cat; tput -T${TERM:-dumb} sgr0; }
reset_color() { tput -T${TERM:-dumb} sgr0; }