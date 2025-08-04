#!/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=w3m
version=0.5.3
pkgver=1

source[0]=https://downloads.sourceforge.net/project/${topdir}/${topdir}/${topdir}-${version}/${topdir}-${version}.tar.gz
#source[0]=https://cytranet-dal.dl.sourceforge.net/project/${topdir}/${topdir}/${topdir}-${version}/${topdir}-${version}.tar.gz?viasf=1
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Redefin package global attributes
pkgedby="Luis E Limon"
pkgdirdesig="tglware"

# Global settings
export CPPFLAGS="-I$prefix/include"
export LDFLAGS="-L$prefix/lib -R$prefix/lib"
topsrcdir=${topdir}-${version}
configure_args+=(--with-ssl --enable-image )
#--with-imagelib=imlib2)

reg prep
prep()
{
    generic_prep
    setdir source
    ${__gsed} -i 's|^#! /bin/sh|#!/bin/bash|' configure
    # Build with libidn2 instead of libidn
    #${__gsed} -i 's/idna.h/idn2.h/' configure WWW/Library/Implementation/HTParse.c
    #${__gsed} -i '/idn-free.h/d' configure WWW/Library/Implementation/HTParse.c
    #${__gsed} -i 's/-lidn/-lidn2/' configure

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
#    doc COPYHEADER COPYING CHANGES README AUTHORS
    doc NEWS TODO ChangeLog doc/README
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
