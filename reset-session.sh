#!/usr/bin/env bash

local DIR="$(find / -iname config.toml | cut -d '/' -f 1-4)"
local SESSION="$(tmux ls | awk -F ':' '{print $1}')"

tmux kill-session -t $SESSION && tmux new -d -s $SESSION
tmux send-keys -t $SESSION.0 '$DIR/build/bin/./geth --config $DIR/config.toml --datadir $DIR/node --cache 18000 --rpc.allow-unprotected-txs --txlookuplimit 0' ENTER
