#!/bin/bash

# scripts/install-cxsparse.sh
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
export PSOPT_CXSPARSE_VERSION="2.2.5"
source ./scripts/prescript.sh

# Download
psoptInstallerDownload CXSparse-${PSOPT_CXSPARSE_VERSION}.tar.gz http://www.cise.ufl.edu/research/sparse/CXSparse/versions/CXSparse-${PSOPT_CXSPARSE_VERSION}.tar.gz

# Compile
cd .packages
if [ ! -d CXSparse ]; then
    tar xzvf ../.download/CXSparse-${PSOPT_CXSPARSE_VERSION}.tar.gz
    cd CXSparse
    make library
    cd ..
fi

# Install
cd CXSparse
make install
cd ../..

# Reset
unset PSOPT_CXSPARSE_VERSION
source ./scripts/postscript.sh
