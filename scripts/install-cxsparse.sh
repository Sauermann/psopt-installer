#!/bin/bash

# scripts/install-suitesparse.sh
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
export PSOPT_SUITESPARSE_VERSION="4.4.3"
source ./scripts/prescript.sh

# Download
psoptInstallerDownload SuiteSparse-${PSOPT_SUITESPARSE_VERSION}.tar.gz http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-${PSOPT_SUITESPARSE_VERSION}.tar.gz

# Compile
cd .packages
if [ ! -d SuiteSparse ]; then
    tar xzvf ../.download/SuiteSparse-${PSOPT_SUITESPARSE_VERSION}.tar.gz
    cd SuiteSparse
    sed -i -n 'H;${x;s/# CC = gcc/CC = gcc/;p;}' SuiteSparse_config/SuiteSparse_config.mk
    sed -i -n 'H;${x;s/# CF = $(CFLAGS) -O3 -fexceptions -m64/CF = $(CFLAGS) -O3 -fexceptions -m64/;p;}' SuiteSparse_config/SuiteSparse_config.mk
    sed -i -n 'H;${x;s#/usr/local#'"$PSOPT_BUILD_DIR"'/.target#g;p;}' SuiteSparse_config/SuiteSparse_config.mk
    cd SuiteSparse_config
    make library
    cd ../CXSparse
    make library
    cd ../..
fi

# Install
cd SuiteSparse/SuiteSparse_config
make install
cd ../CXSparse
make install
cd ../../..

# Reset
unset PSOPT_SUITESPARSE_VERSION
source ./scripts/postscript.sh
