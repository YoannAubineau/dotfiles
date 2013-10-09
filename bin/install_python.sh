#!/usr/bin/env bash
# Install cPython interpreter from source
# usage: install_python.sh <version>

set -x
set -e

VERSION=$1

mkdir -p /usr/src/python-$VERSION
cd /usr/src/python-$VERSION


# Install prerequisite libraries

DEPENDENCIES="
    dpkg-dev
    make
    libreadline6-dev
    libsqlite3-dev
    libxslt1-dev
    libxml2-dev
    zlib1g-dev
    libbz2-dev
"
command -v apt-get && sudo apt-get install $DEPENDENCIES


# Get Python sources

URL="http://www.python.org/ftp/python/$VERSION/Python-$VERSION.tar.bz2"

FILENAME=$(basename $URL)
if [ ! -f $FILENAME ]
then
    wget $URL
fi

DIRNAME=${FILENAME%.tar.*}
if [ ! -d $DIRNAME ]
then
    tar xvjf $FILENAME
fi


# Compile and install Python interpreter

cd "$DIRNAME"

[ -d '/System' ] && PREFIX='/System' || PREFIX='/opt'
TARGETDIR="$PREFIX/$(echo $DIRNAME | tr '[A-Z]' '[a-z]')"

export LDFLAGS="-L/usr/lib/$(dpkg-architecture -qDEB_HOST_MULTIARCH)"

./configure --prefix="$TARGETDIR"
make
sudo make install

cd ..

PYTHON=$TARGETDIR/bin/python${VERSION::3}


# Bootstrap distribute package (required by pip)

URL="http://python-distribute.org/distribute_setup.py"
wget --no-check-certificate --no-clobber $URL
sudo $PYTHON $(basename $URL)


# Install pip package installer

URL="https://github.com/pypa/pip/raw/master/contrib/get-pip.py"
wget --no-check-certificate --no-clobber $URL
sudo $PYTHON $(basename $URL)

sudo chmod o+r $TARGETDIR/lib/python${VERSION::3}/site-packages/pip-*/top_level.txt
sudo chmod o+r $TARGETDIR/lib/python${VERSION::3}/site-packages/pip-*/entry_points.txt

PIP="$TARGETDIR/bin/pip"


# Install virtualenv

sudo $PIP install virtualenv


# Install system-wide distribute

PYTHON="/usr/bin/python"
URL="http://python-distribute.org/distribute_setup.py"
wget --no-check-certificate --no-clobber $URL
sudo $PYTHON $(basename $URL)

# Install system-wide virtualenvwrapper

command -v apt-get && sudo apt-get install python-setuptools
sudo easy_install --upgrade virtualenvwrapper

