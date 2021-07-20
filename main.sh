#!/usr/bin/env bash

set -e

. funcs.conf

if [ $(get_version) = "ubuntu" ] || [ $(get_version) = "debian" ]; then
    get_msg "updating environment..."
    apt-get update && apt-get upgrade -y

    get_msg "installing packages..."
    apt-get install -y build-essential python3-venv hdparm \
                       python3-pip libssl-dev unzip netcat \
                       python3-dev libffi-dev golang nmap \
                       inxi vim git tmux htop jq

    get_msg "setting paths..."
    [ ! -d "/opt/bsc" ] || rm -rf /opt/bsc && get_clone_repo
    cd bsc && make -s geth

    get_msg "get mainnet $(get_latest_tag)"
    get_latest_release
    unzip -q mainnet.zip && rm -f $_

    get_msg "running node..."
    get_open_session && sleep 3

    get_msg "installation completed..."

    get_msg "default directory/logs"
    printf "/opt/bsc\n"
    printf "/opt/install.log\n"

    get_msg "initial tmux"
    printf "$ tmux ls; #list sessions\n"
    printf "$ tmux attach -t fullnode; #attach session\n"
else
    get_msg "OS not supported..."
    exit 1
fi
