#!/bin/bash

# scripts/install-openblas-windows.sh
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
export PSOPT_OPENBLAS_VERSION="0.2.13"

# Download
source ./scripts/prescript.sh
psoptInstallerDownload OpenBLAS-v${PSOPT_OPENBLAS_VERSION}-x86_64.tar.gz https://github.com/xianyi/OpenBLAS/archive/v${PSOPT_OPENBLAS_VERSION}.tar.gz

# Hide most windows paths
export PSOPT_ORIGINAL_PATH=$PATH
export PATH=".:/mingw/bin:/bin:/c/Windows/System32"

# Compile
mkdir -p .packages
cd .packages
if [ ! -d OpenBLAS-${PSOPT_OPENBLAS_VERSION} ]; then
    tar xzvf ../.download/OpenBLAS-v${PSOPT_OPENBLAS_VERSION}-x86_64.tar.gz
    cd OpenBLAS-${PSOPT_OPENBLAS_VERSION}
    make
    cd ..
fi

# Install
cd OpenBLAS-${PSOPT_OPENBLAS_VERSION}
make PREFIX=${PSOPT_BUILD_DIR}/.target install
cd ../..

# Reset
export PATH=$ORIGINAL_PATH
unset PSOPT_ORIGINAL_PATH
unset PSOPT_OPENBLAS_VERSION

source ./scripts/postscript.sh
