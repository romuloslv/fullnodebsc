#!/usr/bin/env bash

function msg() {
  printf "$(tput setaf 2)\n[ INFO ]$(tput sgr 0) $*\n"
}

function get_latest_tag() {
  printf "$(curl -s "https://api.github.com/repos/binance-chain/bsc/tags" | jq -r '.[0].name')"
}

function get_latest_release() {
  curl -sL https://api.github.com/repos/binance-chain/bsc/releases/latest | jq -r '.assets[2].browser_download_url' | wget -i -
}

function get_clone_repo() {
  git clone -q https://github.com/binance-chain/bsc
}
