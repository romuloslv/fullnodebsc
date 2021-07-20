#!/usr/bin/env bash

set -e

. funcs.conf

if [ $(get_version) = "ubuntu" ] || [ $(get_version) = "debian" ]; then
    (get_msg "updating environment..."
    (apt-get update
     apt-get upgrade -y) >> install.log

    get_msg "installing packages..."
    (apt-get install -y build-essential python3-venv hdparm \
                        python3-pip libssl-dev unzip netcat \
                        python3-dev libffi-dev golang nmap \
                        inxi vim git tmux htop jq) >> install.log

    get_msg "setting paths..."
    cd /opt && [ -d "/opt/bsc" ] || get_clone_repo
    cd bsc && make geth >> install.log

    get_msg "get mainnet $(get_latest_tag)"
    get_latest_release
    unzip -q mainnet.zip && rm -f $_

    get_msg "running node..."
    tmux new -d -s fullnode
    tmux send-keys -t fullnode.0 './build/bin/geth --datadir node init genesis.json' ENTER
    tmux send-keys -t fullnode.0 './build/bin/geth --config ./config.toml --datadir ./node --cache 18000 --rpc.allow-unprotected-txs --txlookuplimit 0' ENTER
    sleep 3

    get_msg "default directory"
    ls -latr /opt/bsc

    get_msg "initial tmux"
    echo "$ tmux ls; #list sessions"
    echo "$ tmux attach -t fullnode; #attach session"

    get_msg "installation completed...") | tee install.log
else
    get_msg "OS not supported..."
    exit 1
fi
