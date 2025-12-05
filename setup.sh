#!/bin/sh

BRIGHT_RED="\033[91m"
BRIGHT_GREEN="\033[92m"
BRIGHT_YELLOW="\033[93m"
RESET="\033[0m"

command -v sudo >/dev/null 2>&1 || { echo "Not found 'sudo' command"; exit; }

if command -v rustc >/dev/null 2>&1; then
    echo "${BRIGHT_GREEN}>> Rust already installed <<${RESET}"
else
    echo "${BRIGHT_RED}>> Rust not found <<${RESET}"
    echo "${BRIGHT_YELLOW}Installing...${RESET}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -y | sh -s -- -y
fi

if command -v nix >/dev/null 2>&1; then
    echo "${BRIGHT_GREEN}>> Nix already installed <<${RESET}"
else
    echo "${BRIGHT_RED}>> Nix not found <<${RESET}"
    echo "${BRIGHT_YELLOW}Installing...${RESET}"
    curl -L https://nixos.org/nix/install | sh -s -- --daemon
fi
