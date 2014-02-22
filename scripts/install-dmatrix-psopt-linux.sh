#!/bin/bash

# scripts/install-dmatrix-psopt-linux.sh
# This file is part of Psopt Installer.
#
# Psopt Installer is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Psopt Installer is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Psopt Installer.  If not, see
# <http://www.gnu.org/licenses/>.

psoptInstallerDownload Psopt3.tgz http://psopt.googlecode.com/files/Psopt3.tgz
psoptInstallerDownload patch_3.02.zip http://psopt.googlecode.com/files/patch_3.02.zip


cd .packages
if [ ! -d Psopt3 ]; then
    tar xzvf ../.download/Psopt3.tgz
    # DMatrix
    cd Psopt3/dmatrix/lib
    sed -i -n 'H;${x;s#-I$(CXSPARSE)/Include -I$(LUSOL) -I$(IPOPTINCDIR)#-I'"$PSOPT_BUILD_DIR"'/.target/include#g;p;}' Makefile
    make
    # install DMatrix
    cp libdmatrix.a $PSOPT_BUILD_DIR/.target/lib
    cd ..
    cp include/dmatrixv.h $PSOPT_BUILD_DIR/.target/include
    cd ..
    # PSOPT patching to new release
    unzip ../../.download/patch_3.02.zip
    cp patch_3.02/psopt.cxx PSOPT/src/
    # Apply local patches
    dos2unix PSOPT/src/psopt.cxx
    dos2unix PSOPT/src/psopt.h
    patch -p1 < $PSOPT_BUILD_DIR/patches/psopt-gnuplot-linux.patch
    patch -p1 < $PSOPT_BUILD_DIR/patches/psopt-c++0x-windows.patch
    patch -p1 < $PSOPT_BUILD_DIR/patches/psopt-lambdafunction-windows.patch
    patch -p1 < $PSOPT_BUILD_DIR/patches/psopt-bugfix-static-variable.patch
    patch -p1 < $PSOPT_BUILD_DIR/patches/psopt-ipopt-3-11-7-compatibility.patch
    # PSOPT static library
    sed -i -n 'H;${x;s#-I$(DMATRIXDIR)/include##g;p;}' PSOPT/lib/Makefile
    sed -i -n 'H;${x;s#-I$(CXSPARSE)/Include -I$(LUSOL) -I$(IPOPTINCDIR)#-I'"$PSOPT_BUILD_DIR"'/.target/include -I'"$PSOPT_BUILD_DIR"'/.target/include/coin#g;p;}' PSOPT/lib/Makefile
    make ./PSOPT/lib/libpsopt.a
    cd ..
fi
# Install Psopt
cp Psopt3/PSOPT/lib/libpsopt.a $PSOPT_BUILD_DIR/.target/lib
cp Psopt3/PSOPT/src/psopt.h $PSOPT_BUILD_DIR/.target/include
cd ..
