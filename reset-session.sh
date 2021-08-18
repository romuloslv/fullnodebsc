#!/usr/bin/env bash

sync; echo 3 > /proc/sys/vm/drop_caches

function variables() {
  export DIR="$(find / -iname config.toml 2>/dev/null | cut -d '/' -f 1-3)"
  export SESSION="$(tmux ls | awk -F ':' '{print $1}')"
}

variables

[ -z $SESSION ] && tmux new -d -s fullnode && variables

tmux kill-session -t $SESSION && tmux new -d -s $SESSION
tmux send-keys -t $SESSION.0 '$DIR/build/bin/./geth --config $DIR/config.toml --datadir $DIR/node --cache 18000 --rpc.allow-unprotected-txs --txlookuplimit 0' ENTER
printf "Session reseted...\n"
