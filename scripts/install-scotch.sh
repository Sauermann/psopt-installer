#!/bin/bash

# scripts/install-scotch.sh
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

# Version
export PSOPT_SCOTCH_VERSION="6.0.0"

# Download
source ./scripts/utilities.sh
psoptInstallerDownload scotch_${PSOPT_SCOTCH_VERSION}_esmumps.tar.gz https://gforge.inria.fr/frs/download.php/31832/scotch_${PSOPT_SCOTCH_VERSION}_esmumps.tar.gz

# Handle existence of Variable
if [ -z "${PSOPT_BUILD_DIR+x}" ]; then
    PSOPT_BUILD_DIR=$(pwd)
fi

# Compile
mkdir -p .packages
cd .packages
if [ ! -d scotch_${PSOPT_SCOTCH_VERSION}_esmumps ]; then
    tar xzvf ../.download/scotch_${PSOPT_SCOTCH_VERSION}_esmumps.tar.gz
    cd scotch_${PSOPT_SCOTCH_VERSION}_esmumps
    patch -p1 < $PSOPT_BUILD_DIR/patches/scotch-mingw-64.patch
    cd src
    make esmumps
    cd ../..
fi

# Install
mkdir -p $PSOPT_BUILD_DIR/.target/lib
mkdir -p $PSOPT_BUILD_DIR/.target/include
cd scotch_${PSOPT_SCOTCH_VERSION}_esmumps
cp include/scotch.h $PSOPT_BUILD_DIR/.target/include
cp lib/*.a $PSOPT_BUILD_DIR/.target/lib
cd ../..

# Reset
unset PSOPT_SCOTCH_VERSION
