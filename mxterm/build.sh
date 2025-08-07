#!/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=mxterm
version=129
pkgver=1

# https://downloads.sourceforge.net/project/aax/mxterm/129/mxterm_129.tar.gz
source[0]=https://downloads.sourceforge.net/project/aax/${topdir}/${version}/${topdir}_${version}.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Redefin package global attributes
pkgedby="Luis E Limon"
pkgdirdesig="tgcsware"
pkgprefix="TGCS"
email="9660709+llimon@users.noreply.github.com"


prefix="$prefix/openwin"
echo "new prefix $prefix"

generic_configure=0

# Global settings
export CFLAGS="-I/usr/openwin/include -I$prefix/include -I/usr/openwin/share/include -I/usr/tgcware/include -L$prefix/lib -R$prefix/lib -R/usr/tgcware/lib -L/usr/tgcware/lib"
export LDFLAGS="-L$prefix/lib -R$prefix/lib -R/usr/tgcware/lib -L/usr/tgcware/lib"
configure_args+=(--prefix $prefix)

reg prep
prep()
{
    generic_prep
    setdir source
    ${__gsed} -i 's|^#! /bin/sh|#!/usr/tgcware/bin/bash|' configure

}

run_configure()
{
  echo "LDFLAGS=$LDFLAGS"
./configure --prefix=$prefix --mandir=/usr/tgcware/share/man --infodir=$prefix/share/info 
}

reg build
build()
{
    generic_build
}

reg check
check()
{
    generic_check
}

reg install
install()
{
    generic_install DESTDIR
}

reg pack
pack()
{
    generic_pack
}

reg distclean
distclean()
{
    clean distclean
}

###################################################
# No need to look below here
###################################################
build_sh $*
