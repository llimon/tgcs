#!/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=hexedit
version=1.4.2
version_major="${version%.*}"

pkgver=1

# https://github.com/pixel/hexedit/archive/refs/tags/1.4.2.tar.gz
source[0]=https://github.com/pixel/hexedit/archive/refs/tags/${version}.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Redefin package global attributes
pkgedby="Luis E Limon"
pkgdirdesig="tgcsware"
pkgprefix="TGCS"
email="9660709+llimon@users.noreply.github.com"

# Global settings
export CPPFLAGS="-I$prefix/include"
export LDFLAGS="-L$prefix/lib -R$prefix/lib"
topsrcdir=${topdir}-${version}
#configure_args+=()

reg prep
prep()
{	
	 get_files
    #generic_prep
    #mv  ${srcdir}
	 mv -v ${srcfiles}/${version}.tar.gz ${srcfiles}/${topdir}-${version}.tar.gz
    mkdir -p ${srcdir}
	 #setdir ${srcfile}
	 setdir ${srcdir}
    #tar -zxvf ${srcfiles}/${topdir}-${version}.tar.gz
    tar -zxvf ${srcfiles}/${topdir}-${version}.tar.gz
    setdir source
    
	 
    ./autogen.sh
    #${__gsed} -i 's/-lcurses/-lncurses/' configure
    ${__gsed} -i 's|^#!/bin/bash|#!/usr/tgcware/bin/bash|' configure
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
    DESTDIR=${stagedir}
    generic_install DESTDIR
    doc COPYING README.md TODO
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
