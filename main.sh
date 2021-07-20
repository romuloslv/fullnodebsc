#!/usr/bin/env bash

. funcs.conf
version=$(grep "^ID=" /etc/os-release | awk -F '=' '{print $2}')

if [ $version = "ubuntu" ] || [ $version = "debian" ]; then
	(msg "updating environment..."
	apt update -qq && \
	apt list --upgradable && \
	apt upgrade -y
	
	msg "installing packages..."
	apt-get install -y build-essential python3-venv hdparm \
                           python3-pip libssl-dev unzip netcat \
                           python3-dev libffi-dev golang nmap \
                           inxi vim git tmux htop jq
	
	msg "setting paths..."
	get_clone_repo
	cd bsc && make geth
	
	msg "get mainnet $(get_latest_tag)"
	get_latest_release
	unzip -q mainnet.zip && rm -f $_
	
	msg "running node..."
	tmux new -d -s fullnode
	tmux send-keys -t fullnode.0 './build/bin/geth --datadir node init genesis.json' ENTER
	tmux send-keys -t fullnode.0 './build/bin/geth --config ./config.toml --datadir ./node --cache 18000 --rpc.allow-unprotected-txs --txlookuplimit 0' ENTER) | tee install.log
else
	printf "OS not supported..."
	exit 1
fi
