#!/usr/bin/env bash

. funcs.sh

msg "updating environment..."
apt update -qq && \
apt list --upgradable && \
apt upgrade

msg "installing packages..."
apt install -y build-essential python3-venv \
               python3-pip libssl-dev unzip \
			   python3-dev libffi-dev golang \
			   inxi hdparm vim git tmux htop \
			   ncurses nc jq

msg "setting paths..."
get_clone_repo
cd bsc && make geth

msg "get mainnet $(get_latest_tag)"
get_latest_release
unzip -q mainnet.zip && rm -f $_

msg "running node..."
tmux new -d -s fullnode
tmux send-keys -t fullnode.0 './build/bin/geth --datadir node init genesis.json' ENTER
tmux send-keys -t fullnode.0 './build/bin/geth --config ./config.toml --datadir ./node --cache 18000 --rpc.allow-unprotected-txs --txlookuplimit 0' ENTER
