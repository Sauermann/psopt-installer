#!/bin/bash

# scripts/install-scotch-linux.sh
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

psoptInstallerDownload scotch_6.0.0_esmumps.tar.gz https://gforge.inria.fr/frs/download.php/31832/scotch_6.0.0_esmumps.tar.gz

cd .packages
if [ ! -d scotch_6.0.0_esmumps ]; then
    tar xzvf ../.download/scotch_6.0.0_esmumps.tar.gz
    cd scotch_6.0.0_esmumps/src
    patch -p2 < $PSOPT_BUILD_DIR/patches/scotch-linux.patch
    ln -s Make.inc/Makefile.inc.x86-64_pc_linux2 Makefile.inc
    make esmumps
    cd ../..
fi
cd scotch_6.0.0_esmumps
cp include/scotch.h $PSOPT_BUILD_DIR/.target/include
cp lib/*.a $PSOPT_BUILD_DIR/.target/lib
cd ../..
