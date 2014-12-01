#!/usr/bin/env bash
# Install cPython interpreter from source
# usage: install_python.sh <version>

set -x
set -e

VERSION=$1
VERSION_MAJOR=${VERSION::1}
VERSION_MINOR=${VERSION::3}


# Install prerequisite libraries

DEPENDENCIES="
    dpkg-dev
    libbz2-dev
    libreadline6-dev
    libsqlite3-dev
    libssl-dev
    libxml2-dev
    libxslt1-dev
    make
    zlib1g-dev
"
command -v apt-get && sudo apt-get install $DEPENDENCIES


# Get Python sources

mkdir -p /usr/local/src/python-$VERSION
cd /usr/local/src/python-$VERSION

URL="http://www.python.org/ftp/python/$VERSION/Python-$VERSION.tgz"

FILENAME=$(basename $URL)
if [[ ! -f $FILENAME ]]; then
    wget $URL
fi

DIRNAME=${FILENAME%.tgz}
if [[ ! -d $DIRNAME ]]; then
    tar xvzf $FILENAME
fi


# Compile and install Python interpreter

cd $DIRNAME

[[ -d "/System" ]] && PREFIX="/System" || PREFIX="/opt"
TARGETDIR="$PREFIX/$(echo $DIRNAME | tr '[A-Z]' '[a-z]')"

export LDFLAGS="-L/usr/lib/$(dpkg-architecture -qDEB_HOST_MULTIARCH)"

./configure --prefix=$TARGETDIR

CPU_COUNT=$(grep -c ^processor /proc/cpuinfo)
make -j$CPU_COUNT

sudo make install

cd ..

PYTHON="$TARGETDIR/bin/python$VERSION_MINOR"


# Install pip package installer

URL="https://github.com/pypa/pip/raw/master/contrib/get-pip.py"
wget --no-check-certificate --no-clobber $URL
sudo $PYTHON $(basename $URL)

sudo chmod o+r $TARGETDIR/lib/python$VERSION_MINOR/site-packages/pip-*/top_level.txt
sudo chmod o+r $TARGETDIR/lib/python$VERSION_MINOR/site-packages/pip-*/entry_points.txt

PIP="$TARGETDIR/bin/pip"


# Install virtualenv

if [[ $VERSION_MAJOR == "2" ]]; then
    sudo $PIP install virtualenv
fi


# Install system-wide virtualenvwrapper

command -v apt-get && sudo apt-get install python-setuptools
sudo easy_install --upgrade virtualenvwrapper


echo "done"

