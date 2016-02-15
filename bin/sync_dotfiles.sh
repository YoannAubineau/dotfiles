#!/usr/bin/env bash

if [[ $# -eq 0 ]]; then
    TARGETS=$(grep -e '#sync-dotfiles' .ssh/config | sed 's/\s+/\s/g' | cut -d' ' -f2)
else
    TARGETS="$@"
fi

for TARGET in ${TARGETS}; do
    echo "-------------------------------------------------------------------------------"
    echo "Syncing dotfiles to ${TARGET^^}…"

    CMD="rsync -avz ~/.dotfiles ${TARGET}: --delete | grep -v '^$' && chmod -R go=--- ~/.dotfiles && ssh ${TARGET} .dotfiles/install.py"
    [[ $ASYNC -eq 1 ]] && CMD="(($CMD) 2>&1 | sed 's/^/[$TARGET] /')&"
    eval $CMD
done

