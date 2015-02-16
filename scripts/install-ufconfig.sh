#!/bin/bash

# scripts/install-ufconfig.sh
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
export PSOPT_UFCONFIG_VERSION="3.6.1"
source ./scripts/prescript.sh

# Download
psoptInstallerDownload UFconfig-${PSOPT_UFCONFIG_VERSION}.tar.gz http://www.cise.ufl.edu/research/sparse/SuiteSparse_config/UFconfig-${PSOPT_UFCONFIG_VERSION}.tar.gz

# Compile
cd .packages
if [ ! -d UFconfig ]; then
    tar xzvf ../.download/UFconfig-${PSOPT_UFCONFIG_VERSION}.tar.gz
    cd UFconfig
    sed -i -n 'H;${x;s/CC = cc/CC = gcc/;p;}' UFconfig.mk
    sed -i -n 'H;${x;s#/usr/local#'"$PSOPT_BUILD_DIR"'/.target#g;p;}' UFconfig.mk
    make
    cd ..
fi

# Install
cd UFconfig
make install
cd ../..

# Reset
unset PSOPT_UFCONFIG_VERSION
source ./scripts/postscript.sh
