#!/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=xpm
version=3.4k
version_major="${version%.*}"

pkgver=1

# https://fossies.org/linux/misc/old/xpm-3.4k.tar.gz
source[0]=https://fossies.org/linux/misc/old/${topdir}-${version}.tar.gz
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

#topsrcdir="${topdir}${version}"

reg prep
prep()
{	
    generic_prep
    
    setdir source


	 xmkmf -a || echo "error running xmkmf" 


   for make_file in Makefile sxpm/Makefile cxpm/Makefile lib/Makefile; do
		echo "Patching ${make_file}"

    	${__gsed} -i "s|\( CC[[:space:]]*=\).*|\1 gcc |" ${make_file}
    	${__gsed} -i "s|\(PREPROCESSCMD[[:space:]]*=\).*|\1 gcc -E \$(STD_CPP_DEFINES) |" ${make_file}
    	#${__gsed} -i 's|-kPIC|-fPIC|g' Makefile
    	${__gsed} -i "s|\(CCOPTIONS[[:space:]]*=\).*|\1 -std=gnu99|" ${make_file}
    	${__gsed} -i "s|\(PICFLAGS[[:space:]]*=\).*|\1 -fPIC|" ${make_file}
    	${__gsed} -i "s|\(CXXPICFLAGS[[:space:]]*=\).*|\1 -fPIC|" ${make_file}
    	${__gsed} -i "s|\(BINDIR[[:space:]]*=\).*|\1 $stagedir/usr/tgcware/openwin/bin|" ${make_file}
    	${__gsed} -i "s|\(MANPATH[[:space:]]*=\).*|\1 $stagedir/usr/tgcware/openwin/share/man/man1|" ${make_file}
    	#${__gsed} -i "s|\(BUILDINCDIR[[:space:]]*=\).*|\1 $stagedir/usr/tgcware/openwin/include|" ${make_file}
    	${__gsed} -i "s|\(XPMINCDIR[[:space:]]*=\).*|\1 $stagedir/usr/tgcware/openwin/include|" ${make_file}
    	${__gsed} -i "s|\(XPMLIBDIR[[:space:]]*=\).*|\1 $stagedir/usr/tgcware/openwin/lib|" ${make_file}
	done
    
}

reg build
build()
{
	 no_configure=1
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
	
	setdir source
   DESTDIR=${stagedir}
   mkdir -p $DESTDIR
	echo "destdir $DESTDIR"
   make install
   make install.man

}

reg pack
pack()
{
	 DESTDIR=${stagedir}
    #setdir stage
    generic_pack DESTDIR
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
