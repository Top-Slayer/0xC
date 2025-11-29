#!/usr/bin/env sh

export XDG_CONFIG_HOME="$PWD/config"
export XDG_DATA_HOME="$PWD/local/share"
export XDG_STATE_HOME="$PWD/local/state"
export XDG_CACHE_HOME="$PWD/local/cache"

echo $XDG_CONFIG_HOME
nvim "$@"
