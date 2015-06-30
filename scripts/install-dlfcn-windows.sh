#!/bin/bash

# scripts/install-dlfcn-windows.sh
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

# Setup
export PSOPT_DLFCN_VERSION="19-6"
source ./scripts/prescript.sh

# Download
psoptInstallerDownload dlfcn-win32-r${PSOPT_DLFCN_VERSION}-mingw_i686-src.tar.xz http://lrn.no-ip.info/packages/i686-w64-mingw/dlfcn-win32/r${PSOPT_DLFCN_VERSION}/dlfcn-win32-r${PSOPT_DLFCN_VERSION}-mingw_i686-src.tar.xz

# Compile
cd .packages
if [ ! -d dlfcn-${PSOPT_DLFCN_VERSION} ]; then
    mkdir dlfcn-${PSOPT_DLFCN_VERSION}
    cd dlfcn-${PSOPT_DLFCN_VERSION}
    tar xJvf ../../.download/dlfcn-win32-r${PSOPT_DLFCN_VERSION}-mingw_i686-src.tar.xz
    sed -i -n 'H;${x;s/sha512sum/shasum/;p;}' pkgbuild.sh
    sed -i -n 'H;${x;s/do_fixinstall=1/do_fixinstall=0/;p;}' pkgbuild.sh
    sed -i -n 'H;${x;s/do_pack=1/do_pack=0/;p;}' pkgbuild.sh
    sed -i -n 'H;${x;s/do_clean=1/do_clean=0/;p;}' pkgbuild.sh
    sed -i -n 'H;${x;s#instdir=${pkgbuilddir}/inst#instdir=$PSOPT_BUILD_DIR/.target#;p;}' pkgbuild.sh
    sed -i -n 'H;${x;s/rm -rf ${blddir} ${instdir}/rm -rf ${blddir}/g;p;}' pkgbuild.sh
    sed -i -n 'H;${x;s#prefix=/mingw#prefix=#;p;}' pkgbuild.sh
    cd ..
fi

# Install
cd dlfcn-${PSOPT_DLFCN_VERSION}
export arch=WIN
./pkgbuild.sh
unset arch
cd ../..

# Reset
unset PSOPT_DLFCN_VERSION

source ./scripts/postscript.sh
