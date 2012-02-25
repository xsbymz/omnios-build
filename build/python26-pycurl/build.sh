#!/usr/bin/bash

# Load support functions
. ../../lib/functions.sh

PATH=/opt/gcc-4.6.2/bin:$PATH

PROG=pycurl     # App name
VER=7.19.0      # App version
PVER=0.151002   # Package Version
PKG=library/python-2/pycurl # Package name (without prefix)
SUMMARY="Python bindings for libcurl"
DESC="PycURL provides a thin layer of Python bindings on top of libcurl."

DEPENDS="runtime/python-26 library/security/openssl@1.0.0 web/curl@7.24"

PYTHONPATH=/usr
PYTHON=$PYTHONPATH/bin/python2.6
PYTHONLIB=$PYTHONPATH/lib

python_build() {
    logmsg "Building using python setup.py"
    pushd $TMPDIR/$BUILDDIR > /dev/null
    ISALIST=i386
    export ISALIST
    logmsg "--- setup.py (32) build"
    logcmd $PYTHON ./setup.py build_ext ||
        logerr "--- build failed"
    logmsg "--- setup.py (32) install"
    logcmd $PYTHON \
        ./setup.py install --root=$DESTDIR ||
        logerr "--- install failed"

    ISALIST="amd64 i386"
    export ISALIST
    logmsg "--- setup.py (64) build"
    logcmd $PYTHON ./setup.py build_ext ||
        logerr "--- build failed"
    logmsg "--- setup.py (64) install"
    logcmd $PYTHON \
        ./setup.py install --root=$DESTDIR ||
        logerr "--- install failed"
    popd > /dev/null

    mv $DESTDIR/usr/lib/python2.6/site-packages $DESTDIR/usr/lib/python2.6/vendor-packages ||
        logerr "Cannot move from site-packages to vendor-packages"
}

ISALIST=i386
export ISALIST
init
download_source $PROG $PROG $VER
patch_source
prep_build
python_build
ISALIST="i386 amd64"
export ISALIST
VER=7.19.0.1
make_package
clean_up