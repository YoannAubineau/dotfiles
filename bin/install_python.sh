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


# Patch Python 2.6

if [[ $VERSION_MINOR == "2.6" ]]; then
    perl -ne '/^#python-2.6-remove_SSLv2.patch:(.*)/ && print $1."\n"' $0 | patch -p1 -d $DIRNAME
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


# Install virtualenvwrapper

sudo $PIP install virtualenvwrapper

# Install system-wide virtualenvwrapper

command -v apt-get && sudo apt-get install python-setuptools
sudo easy_install --upgrade virtualenvwrapper


echo "done"

#python-2.6-remove_SSLv2.patch:diff -r c9910fd022fc -r 0cc743bd3a6d Doc/library/ssl.rst
#python-2.6-remove_SSLv2.patch:--- a/Doc/library/ssl.rst	Tue Apr 10 10:59:35 2012 -0400
#python-2.6-remove_SSLv2.patch:+++ b/Doc/library/ssl.rst	Tue May 29 14:31:16 2012 -0700
#python-2.6-remove_SSLv2.patch:@@ -218,14 +218,6 @@
#python-2.6-remove_SSLv2.patch:    Note that use of this setting requires a valid certificate validation file
#python-2.6-remove_SSLv2.patch:    also be passed as a value of the ``ca_certs`` parameter.
#python-2.6-remove_SSLv2.patch:
#python-2.6-remove_SSLv2.patch:-.. data:: PROTOCOL_SSLv2
#python-2.6-remove_SSLv2.patch:-
#python-2.6-remove_SSLv2.patch:-   Selects SSL version 2 as the channel encryption protocol.
#python-2.6-remove_SSLv2.patch:-
#python-2.6-remove_SSLv2.patch:-   .. warning::
#python-2.6-remove_SSLv2.patch:-
#python-2.6-remove_SSLv2.patch:-      SSL version 2 is insecure.  Its use is highly discouraged.
#python-2.6-remove_SSLv2.patch:-
#python-2.6-remove_SSLv2.patch: .. data:: PROTOCOL_SSLv23
#python-2.6-remove_SSLv2.patch:
#python-2.6-remove_SSLv2.patch:    Selects SSL version 2 or 3 as the channel encryption protocol.  This is a
#python-2.6-remove_SSLv2.patch:diff -r c9910fd022fc -r 0cc743bd3a6d Lib/ssl.py
#python-2.6-remove_SSLv2.patch:--- a/Lib/ssl.py	Tue Apr 10 10:59:35 2012 -0400
#python-2.6-remove_SSLv2.patch:+++ b/Lib/ssl.py	Tue May 29 14:31:16 2012 -0700
#python-2.6-remove_SSLv2.patch:@@ -49,7 +49,6 @@
#python-2.6-remove_SSLv2.patch:
#python-2.6-remove_SSLv2.patch: The following constants identify various SSL protocol variants:
#python-2.6-remove_SSLv2.patch:
#python-2.6-remove_SSLv2.patch:-PROTOCOL_SSLv2
#python-2.6-remove_SSLv2.patch: PROTOCOL_SSLv3
#python-2.6-remove_SSLv2.patch: PROTOCOL_SSLv23
#python-2.6-remove_SSLv2.patch: PROTOCOL_TLSv1
#python-2.6-remove_SSLv2.patch:@@ -61,7 +60,7 @@
#python-2.6-remove_SSLv2.patch:
#python-2.6-remove_SSLv2.patch: from _ssl import SSLError
#python-2.6-remove_SSLv2.patch: from _ssl import CERT_NONE, CERT_OPTIONAL, CERT_REQUIRED
#python-2.6-remove_SSLv2.patch:-from _ssl import PROTOCOL_SSLv2, PROTOCOL_SSLv3, PROTOCOL_SSLv23, PROTOCOL_TLSv1
#python-2.6-remove_SSLv2.patch:+from _ssl import PROTOCOL_SSLv3, PROTOCOL_SSLv23, PROTOCOL_TLSv1
#python-2.6-remove_SSLv2.patch: from _ssl import RAND_status, RAND_egd, RAND_add
#python-2.6-remove_SSLv2.patch: from _ssl import \
#python-2.6-remove_SSLv2.patch:      SSL_ERROR_ZERO_RETURN, \
#python-2.6-remove_SSLv2.patch:@@ -406,8 +405,6 @@
#python-2.6-remove_SSLv2.patch:         return "TLSv1"
#python-2.6-remove_SSLv2.patch:     elif protocol_code == PROTOCOL_SSLv23:
#python-2.6-remove_SSLv2.patch:         return "SSLv23"
#python-2.6-remove_SSLv2.patch:-    elif protocol_code == PROTOCOL_SSLv2:
#python-2.6-remove_SSLv2.patch:-        return "SSLv2"
#python-2.6-remove_SSLv2.patch:     elif protocol_code == PROTOCOL_SSLv3:
#python-2.6-remove_SSLv2.patch:         return "SSLv3"
#python-2.6-remove_SSLv2.patch:     else:
#python-2.6-remove_SSLv2.patch:diff -r c9910fd022fc -r 0cc743bd3a6d Lib/test/test_ssl.py
#python-2.6-remove_SSLv2.patch:--- a/Lib/test/test_ssl.py	Tue Apr 10 10:59:35 2012 -0400
#python-2.6-remove_SSLv2.patch:+++ b/Lib/test/test_ssl.py	Tue May 29 14:31:16 2012 -0700
#python-2.6-remove_SSLv2.patch:@@ -58,7 +58,6 @@
#python-2.6-remove_SSLv2.patch:                 raise
#python-2.6-remove_SSLv2.patch:
#python-2.6-remove_SSLv2.patch:     def test_constants(self):
#python-2.6-remove_SSLv2.patch:-        ssl.PROTOCOL_SSLv2
#python-2.6-remove_SSLv2.patch:         ssl.PROTOCOL_SSLv23
#python-2.6-remove_SSLv2.patch:         ssl.PROTOCOL_SSLv3
#python-2.6-remove_SSLv2.patch:         ssl.PROTOCOL_TLSv1
#python-2.6-remove_SSLv2.patch:@@ -829,19 +828,6 @@
#python-2.6-remove_SSLv2.patch:             bad_cert_test(os.path.join(os.path.dirname(__file__) or os.curdir,
#python-2.6-remove_SSLv2.patch:                                        "badkey.pem"))
#python-2.6-remove_SSLv2.patch:
#python-2.6-remove_SSLv2.patch:-        def test_protocol_sslv2(self):
#python-2.6-remove_SSLv2.patch:-            """Connecting to an SSLv2 server with various client options"""
#python-2.6-remove_SSLv2.patch:-            if test_support.verbose:
#python-2.6-remove_SSLv2.patch:-                sys.stdout.write("\ntest_protocol_sslv2 disabled, "
#python-2.6-remove_SSLv2.patch:-                                 "as it fails on OpenSSL 1.0.0+")
#python-2.6-remove_SSLv2.patch:-            return
#python-2.6-remove_SSLv2.patch:-            try_protocol_combo(ssl.PROTOCOL_SSLv2, ssl.PROTOCOL_SSLv2, True)
#python-2.6-remove_SSLv2.patch:-            try_protocol_combo(ssl.PROTOCOL_SSLv2, ssl.PROTOCOL_SSLv2, True, ssl.CERT_OPTIONAL)
#python-2.6-remove_SSLv2.patch:-            try_protocol_combo(ssl.PROTOCOL_SSLv2, ssl.PROTOCOL_SSLv2, True, ssl.CERT_REQUIRED)
#python-2.6-remove_SSLv2.patch:-            try_protocol_combo(ssl.PROTOCOL_SSLv2, ssl.PROTOCOL_SSLv23, True)
#python-2.6-remove_SSLv2.patch:-            try_protocol_combo(ssl.PROTOCOL_SSLv2, ssl.PROTOCOL_SSLv3, False)
#python-2.6-remove_SSLv2.patch:-            try_protocol_combo(ssl.PROTOCOL_SSLv2, ssl.PROTOCOL_TLSv1, False)
#python-2.6-remove_SSLv2.patch:-
#python-2.6-remove_SSLv2.patch:         def test_protocol_sslv23(self):
#python-2.6-remove_SSLv2.patch:             """Connecting to an SSLv23 server with various client options"""
#python-2.6-remove_SSLv2.patch:             if test_support.verbose:
#python-2.6-remove_SSLv2.patch:@@ -877,7 +863,6 @@
#python-2.6-remove_SSLv2.patch:             try_protocol_combo(ssl.PROTOCOL_SSLv3, ssl.PROTOCOL_SSLv3, True)
#python-2.6-remove_SSLv2.patch:             try_protocol_combo(ssl.PROTOCOL_SSLv3, ssl.PROTOCOL_SSLv3, True, ssl.CERT_OPTIONAL)
#python-2.6-remove_SSLv2.patch:             try_protocol_combo(ssl.PROTOCOL_SSLv3, ssl.PROTOCOL_SSLv3, True, ssl.CERT_REQUIRED)
#python-2.6-remove_SSLv2.patch:-            try_protocol_combo(ssl.PROTOCOL_SSLv3, ssl.PROTOCOL_SSLv2, False)
#python-2.6-remove_SSLv2.patch:             try_protocol_combo(ssl.PROTOCOL_SSLv3, ssl.PROTOCOL_SSLv23, False)
#python-2.6-remove_SSLv2.patch:             try_protocol_combo(ssl.PROTOCOL_SSLv3, ssl.PROTOCOL_TLSv1, False)
#python-2.6-remove_SSLv2.patch:
#python-2.6-remove_SSLv2.patch:@@ -890,7 +875,6 @@
#python-2.6-remove_SSLv2.patch:             try_protocol_combo(ssl.PROTOCOL_TLSv1, ssl.PROTOCOL_TLSv1, True)
#python-2.6-remove_SSLv2.patch:             try_protocol_combo(ssl.PROTOCOL_TLSv1, ssl.PROTOCOL_TLSv1, True, ssl.CERT_OPTIONAL)
#python-2.6-remove_SSLv2.patch:             try_protocol_combo(ssl.PROTOCOL_TLSv1, ssl.PROTOCOL_TLSv1, True, ssl.CERT_REQUIRED)
#python-2.6-remove_SSLv2.patch:-            try_protocol_combo(ssl.PROTOCOL_TLSv1, ssl.PROTOCOL_SSLv2, False)
#python-2.6-remove_SSLv2.patch:             try_protocol_combo(ssl.PROTOCOL_TLSv1, ssl.PROTOCOL_SSLv3, False)
#python-2.6-remove_SSLv2.patch:             try_protocol_combo(ssl.PROTOCOL_TLSv1, ssl.PROTOCOL_SSLv23, False)
#python-2.6-remove_SSLv2.patch:
#python-2.6-remove_SSLv2.patch:diff -r c9910fd022fc -r 0cc743bd3a6d Modules/_ssl.c
#python-2.6-remove_SSLv2.patch:--- a/Modules/_ssl.c	Tue Apr 10 10:59:35 2012 -0400
#python-2.6-remove_SSLv2.patch:+++ b/Modules/_ssl.c	Tue May 29 14:31:16 2012 -0700
#python-2.6-remove_SSLv2.patch:@@ -62,8 +62,7 @@
#python-2.6-remove_SSLv2.patch: };
#python-2.6-remove_SSLv2.patch:
#python-2.6-remove_SSLv2.patch: enum py_ssl_version {
#python-2.6-remove_SSLv2.patch:-    PY_SSL_VERSION_SSL2,
#python-2.6-remove_SSLv2.patch:-    PY_SSL_VERSION_SSL3,
#python-2.6-remove_SSLv2.patch:+    PY_SSL_VERSION_SSL3=1,
#python-2.6-remove_SSLv2.patch:     PY_SSL_VERSION_SSL23,
#python-2.6-remove_SSLv2.patch:     PY_SSL_VERSION_TLS1
#python-2.6-remove_SSLv2.patch: };
#python-2.6-remove_SSLv2.patch:@@ -302,8 +301,6 @@
#python-2.6-remove_SSLv2.patch:         self->ctx = SSL_CTX_new(TLSv1_method()); /* Set up context */
#python-2.6-remove_SSLv2.patch:     else if (proto_version == PY_SSL_VERSION_SSL3)
#python-2.6-remove_SSLv2.patch:         self->ctx = SSL_CTX_new(SSLv3_method()); /* Set up context */
#python-2.6-remove_SSLv2.patch:-    else if (proto_version == PY_SSL_VERSION_SSL2)
#python-2.6-remove_SSLv2.patch:-        self->ctx = SSL_CTX_new(SSLv2_method()); /* Set up context */
#python-2.6-remove_SSLv2.patch:     else if (proto_version == PY_SSL_VERSION_SSL23)
#python-2.6-remove_SSLv2.patch:         self->ctx = SSL_CTX_new(SSLv23_method()); /* Set up context */
#python-2.6-remove_SSLv2.patch:     PySSL_END_ALLOW_THREADS
#python-2.6-remove_SSLv2.patch:@@ -1688,8 +1685,6 @@
#python-2.6-remove_SSLv2.patch:                             PY_SSL_CERT_REQUIRED);
#python-2.6-remove_SSLv2.patch:
#python-2.6-remove_SSLv2.patch:     /* protocol versions */
#python-2.6-remove_SSLv2.patch:-    PyModule_AddIntConstant(m, "PROTOCOL_SSLv2",
#python-2.6-remove_SSLv2.patch:-                            PY_SSL_VERSION_SSL2);
#python-2.6-remove_SSLv2.patch:     PyModule_AddIntConstant(m, "PROTOCOL_SSLv3",
#python-2.6-remove_SSLv2.patch:                             PY_SSL_VERSION_SSL3);
#python-2.6-remove_SSLv2.patch:
