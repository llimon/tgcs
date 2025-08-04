#!/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=libsixel
version=1.7.3
version_major="${version%.*}"

pkgver=1

# https://github.com/saitoha/libsixel/releases/download/v1.8.6/libsixel-1.8.6.tar.gz
source[0]=https://github.com/saitoha/libsixel/releases/download/v${version}/${topdir}-${version}.tar.gz
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
export CPPFLAGS="-I$prefix/include -UHAVE_DIAGNOSTIC_SIGN_CONVERSION"
export LDFLAGS="-L$prefix/lib -R$prefix/lib"
topsrcdir=${topdir}-${version}

# No MAP_ANON for Solaris < 8
[ "$gnu_os_ver" = "2.7" ] && ac_overrides="ac_cv_func_mmap_fixed_mapped=no"

configure_args+=(--with-jpeg --with-png)

reg prep
prep()
{
    generic_prep
    setdir source
    ${__gsed} -i 's|^#!/bin/bash|#!/usr/tgcware/bin/bash|' configure
    #${__gsed} -i 's|LS_CHECK_CFLAG([-\Wsign-conversion]|LS_CHECK_CFLAG([-Wsign-conversion-failme]|' configure.in
    [ "$gnu_os_ver" = "2.7" ] && ${__gsed} -i 's|LS_CHECK_CFLAG(\[-Wsign-conversion\]|LS_CHECK_CFLAG([-Wsign-conversion-failme]|' configure.ac
}

reg build
build()
{
	 setdir source
	 [ "$gnu_os_ver" = "2.7" ] && autoconf 
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
    doc NEWS
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
