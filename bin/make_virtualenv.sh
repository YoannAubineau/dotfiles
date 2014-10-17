#!/usr/bin/env bash
# Create Python virtualenv
# usage: make_virtualenv.sh <version> <virtualenv_name>

set -e -x

VERSION=$1
VIRTUALENV_NAME=$2

VERSION_MAJOR=${VERSION::1}
VERSION_MINOR=${VERSION::3}


# Create virtualenvs root directory

if [[ $WORKON_HOME == "" ]]
then
    WORKON_HOME=~/.virtualenvs
fi

mkdir -p $WORKON_HOME
VIRTUALENV_PATH=$WORKON_HOME/$VIRTUALENV_NAME


# Create new virtualenv with specified name and Python version

[[ -d "/System" ]] && PREFIX="/System" || PREFIX="/opt"
PYTHON=$PREFIX/python-$VERSION/bin/python$VERSION_MINOR

if [[ $VERSION_MAJOR == "3" ]]
then
    VIRTUALENV="$PREFIX/python-$VERSION/bin/pyvenv-$VERSION_MINOR"
    $VIRTUALENV $VIRTUALENV_PATH
else
    VIRTUALENV="$PREFIX/python-$VERSION/bin/virtualenv"
    $VIRTUALENV --python=$PYTHON --no-site-packages $VIRTUALENV_PATH
fi

