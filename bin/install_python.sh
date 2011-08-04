#!/usr/bin/env bash
# Install cPython interpreter from source
# usage: install_python.sh <version>

set -e
set -x

VERSION=$1


# Get Python sources

wget http://www.python.org/ftp/python/$VERSION/Python-$VERSION.tar.bz2
#echo 'aa27bc25725137ba155910bd8e5ddc4f  Python-$VERSION.tar.bz2' | md5sum --check -
tar xvjf Python-$VERSION.tar.bz2


# Compile and install Python interpreter

cd Python-$VERSION/
./configure --prefix=/opt/python-$VERSION/
sudo make install
cd ..

PYTHON=/opt/python-$VERSION/bin/python${VERSION::3}


# Bootstrap distribute package (required by pip)

wget --no-check-certificate http://python-distribute.org/distribute_setup.py
sudo $PYTHON distribute_setup.py


# Install pip package installer

wget --no-check-certificate https://github.com/pypa/pip/raw/master/contrib/get-pip.py
sudo $PYTHON get-pip.py


# Install virtualenv

sudo /opt/python-$VERSION/bin/pip install virtualenv

