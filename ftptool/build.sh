#!/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=Ftptool
version=4.6
version_major="${version%.*}"

pkgver=1

# https://www.ibiblio.org/pub/X11/contrib/utilities/Ftptool4.6.tar.gz
source[0]=https://www.ibiblio.org/pub/X11/contrib/utilities/${topdir}${version}.tar.gz
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

topsrcdir="${topdir}${version}"

reg prep
prep()
{	
    generic_prep
    
    setdir source
#	 get_files
#    #generic_prep
#	 mv -v ${srcfiles}/${version}.tar.gz ${srcfiles}/${topdir}-${version}.tar.gz
#    mkdir -p ${srcdir}
#	 setdir ${srcdir}
#    tar -zxvf ${srcfiles}/${topdir}-${version}.tar.gz
#    setdir source
#    
#	 
#    ./autogen.sh



    ${__gsed} -i 's|# DEFINES= -DSYSV -DSVR4|DEFINES= -DSYSV -DSVR4 -DOWTOOLKIT_WARNING_DISABLED|' Makefile
    #${__gsed} -i 's|# LIBSUNOS5= -L${OPENWINHOME}/lib -lsocket -lnsl -lm|LIBSUNOS5= -L${OPENWINHOME}/lib -lsocket -lnsl -lm|' Makefile
    ${__gsed} -i 's|# LIBSUNOS5= -L${OPENWINHOME}/lib -lsocket -lnsl -lm|LIBSUNOS5=-L/usr/openwin/lib -R/usr/openwin/lib -lsocket -lnsl -lm|' Makefile
    ${__gsed} -i 's|# CC=gcc -g|CC=gcc|' Makefile
    ${__gsed} -i 's|CDEBUGFLAGS = -O -xF|CDEBUGFLAGS = -O -I/usr/openwin/include |' Makefile
    ${__gsed} -i 's|CCOPTIONS = -DSYSV -DSVR4 -xF -Wa,-cg92|CCOPTIONS = -DSYSV -DSVR4 -std=gnu99|' Makefile
    ${__gsed} -i 's|# XVIEW= -DXVIEW3|XVIEW= -DXVIEW3|' Makefile


    ${__gsed} -i "s|^# OPENWINHOME[[:space:]]*=.*|OPENWINHOME= ${prefix}/openwin|" Makefile
    ${__gsed} -i "s|\(BINDIR[[:space:]]*=\).*|\1 \$(OPENWINHOME)/bin|" Makefile
    ${__gsed} -i "s|\(LIBDIR[[:space:]]*=\).*|\1 \$(OPENWINHOME)/lib|" Makefile
    ${__gsed} -i "s|\(MANDIR[[:space:]]*=\).*|\1 /share/man/man1|" Makefile
    ${__gsed} -i "s|\(HELPDIR[[:space:]]*=\).*|\1 \$(OPENWINHOME)/help|" Makefile
    ${__gsed} -i "s|\(DESTDIR[[:space:]]*=\).*|\1 ${stagedir}/usr/tgcware/openwin|" Makefile
    ${__gsed} -i "s|\(MKDIRHIER[[:space:]]*=\).*|\1 /bin/sh /usr/openwin/bin/mkdirhier|" Makefile
    ${__gsed} -i 's|$(INSTALL) -c $(INSTMANFLAGS) ftptool.info $(HELPDIR)/ftptool.info|#$(INSTALL) -c $(INSTMANFLAGS) ftptool.info $(HELPDIR)/ftptool.info|' Makefile
    
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
	 # Note: I'm doing a manual install, cause whit old Make file cannot easily have a stage area
    DESTDIR=${stagedir}
    mkdir -p $DESTDIR
    generic_install DESTDIR
	 cd ${srcdir}/${topsrcdir}
    make install.man


    #echo "Cleaning out stage area"
    #rm -rf $DESTDIR 
	 #mkdir -vp ${stagedir}/man/man1 ${stagedir}/help ${stagedir}/info ${stagedir}/share/docs
    #setdir source
    #cp ftptool ${stagedir}/bin
    #cp ftptool.man ${stagedir}/man/man1
    #cp ftptool.info ${stagedir}/info
    #for a in README README.FIRST WISHLIST BUGS LEGAL_NOTICE; do
	 #  cp -v $a ${stagedir}/share/docs/$a
	 #done
    #doc README TODO README.FIRST WISHLIST BUGS LEGAL_NOTICE
}

reg pack
pack()
{
	 DESTDIR=${stagedir}
    #setdir stage
    generic_pack DESTTDIR
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
