#!/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=ntp
version=4.2.6p5
release_version="${version%p*}"  # Strips .6p5 -> 4.2


pkgver=1

source[0]=https://downloads.nwtime.org/ntp/${release_version}/${topdir}-${version}.tar.gz
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
export CFLAGS="-I$prefix/include -O2 -mcpu=v7"
export LDFLAGS="-L$prefix/lib -R$prefix/lib -lsocket -lnsl"
ac_overrides="ac_cv_header_sys_timepps_h=no ac_cv_header_timepps_h=no"
#topsrcdir=${topdir}-${version}
configure_args+=(--disable-ipv6 --without-crypto --disable-all-clocks)

#topsrcdir="${topdir}${version}"

reg prep
prep()
{	
    generic_prep
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
   doc README COPYRIGHT

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
