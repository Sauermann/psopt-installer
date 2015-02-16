#!/bin/bash

# scripts/install-adolc.sh
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
PSOPT_ADOLC_VERSION="2.4.1"
source ./scripts/prescript.sh

# Download
psoptInstallerDownload ADOL-C-${PSOPT_ADOLC_VERSION}.tgz http://www.coin-or.org/download/source/ADOL-C/ADOL-C-${PSOPT_ADOLC_VERSION}.tgz

# Compile
cd .packages
if [ ! -d ADOL-C-${PSOPT_ADOLC_VERSION} ]; then
    tar xzvf ../.download/ADOL-C-${PSOPT_ADOLC_VERSION}.tgz
    cd ADOL-C-${PSOPT_ADOLC_VERSION}
    ./configure --enable-sparse --enable-static --with-colpack=$PSOPT_BUILD_DIR/.target --prefix $PSOPT_BUILD_DIR/.target
    make
    cd ..
fi

# Install
cd ADOL-C-${PSOPT_ADOLC_VERSION}
make install
cd ../..

# Reset
unset PSOPT_ADOLC_VERSION
source ./scripts/postscript.sh
