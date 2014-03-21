#!/usr/bin/env bash
set -ex

HOME=$1

# Get absolute path to home directory
cd $HOME
HOME=$(pwd)
cd -

USERNAME=$(basename ${HOME%/})

chown -R $USERNAME $HOME
chmod -R u=rwX,g=r-X,o= $HOME
find $HOME -type d -exec chmod g+xs,o+x {} \;

if [ -e $HOME/.dotfiles ]
then
    chown -R $USERNAME:$USERNAME $HOME/.dotfiles
fi

if [ -e $HOME/.ssh ]
then
    chown -R $USERNAME:$USERNAME $HOME/.ssh
    chmod -R g=,o= $HOME/.ssh
fi

if [ -e $HOME/.pgpass ]
then
    chown -R $USERNAME:$USERNAME $HOME/.pgpass
    chmod -R g=,o= $HOME/.pgpass
fi

