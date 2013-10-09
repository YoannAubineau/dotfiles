#!/usr/bin/env bash
# Create Python virtualenv
# usage: make_virtualenv.sh <version> <virtualenv_name>

set -e -x

VERSION=$1
VIRTUALENV_NAME=$2


# Create virtualenvs root directory

if [ "$WORKON_HOME" == "" ]
then
    WORKON_HOME=~/.virtualenvs
fi

mkdir -p $WORKON_HOME


# Create new virtualenv with specified name and Python version

[ -d "/System" ] && PREFIX="/System" || PREFIX="/opt"
PYTHON="$PREFIX/python-$VERSION/bin/python${VERSION::3}"
VIRTUALENV="$PREFIX/python-$VERSION/bin/virtualenv"

$VIRTUALENV --python=$PYTHON --no-site-packages $WORKON_HOME/$VIRTUALENV_NAME


# Install virtualenvwrapper for this virtualenv so that it doesn't break using tmux

#source $WORKON_HOME/$VIRTUALENV_NAME/bin/activate
#pip install virtualenvwrapper
#deactivate

