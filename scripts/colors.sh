#!/bin/bash

RESET='\033[0m'
BOLD='\033[1m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
WHITE='\033[37m'

print_header() {
    echo -e "${BOLD}${CYAN}$*${RESET}"
}

print_option() {
    echo -e "${MAGENTA}$*${RESET}"
}

print_info() {
    echo -e "${BLUE}$*${RESET}"
}

print_success() {
    echo -e "${GREEN}$*${RESET}"
}

print_warning() {
    echo -e "${YELLOW}$*${RESET}"
}

print_error() {
    echo -e "${RED}$*${RESET}"
}
