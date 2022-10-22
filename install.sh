#!/usr/bin/env bash

set -ex

source funcs.conf

if [ $(get_version) = "ubuntu" ] || [ $(get_version) = "debian" ]; then
    get_msg "updating environment..."
    (apt-get update && apt-get upgrade -y) >/dev/null 2>&1

    get_msg "installing packages..."
    (apt-get install -y build-essential python3-venv hdparm \
                        python3-pip libssl-dev unzip netcat \
                        python3-dev libffi-dev htop jq nmap \
                        inxi vim git screen) >/dev/null 2>&1

    get_msg "get golang $(curl -s https://go.dev/VERSION?m=text)"
    [ -d "/usr/local/go" ] && rm -rf /usr/local/go
    install_latest_go

    get_msg "setting paths..."
    [ ! -d "/opt/bsc" ] || rm -rf /opt/bsc && get_clone_repo
    [ -f "/etc/systemd/system/geth.service" ] && rm -rf /etc/systemd/system/geth.service
    mv geth.service /etc/systemd/system/ && useradd -s /sbin/nologin geth || true
    cd /opt/bsc && eval "$(cat ~/.bashrc | tail -n -1)"
    (make geth) >/dev/null 2>&1

    get_msg "get mainnet $(get_latest_tag)"
    get_latest_release
    unzip -q mainnet.zip && rm -f $_
    build/bin/geth --datadir node init genesis.json
    chown -R geth:geth /usr/local/go /opt/bsc genesis.json

    get_msg "running node..."
    create_service_geth
    get_msg "installation completed..."

    get_msg "manipulate logs"
    printf "/opt/bsc/node/bsc.log or journalctl\n"

    get_msg "disclaimer"
    printf "Use systemd to manager your service\n"
else
    get_msg "OS not supported..."
    exit 1
fi
