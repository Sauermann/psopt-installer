#!/bin/bash

# scripts/install-colpack-linux.sh
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

psoptInstallerDownload ColPack-1.0.9.tar.gz http://cscapes.cs.purdue.edu/download/ColPack/ColPack-1.0.9.tar.gz

cd .packages
if [ ! -d ColPack-1.0.9 ]; then
    tar xzvf ../.download/ColPack-1.0.9.tar.gz
    cd ColPack-1.0.9
    ./configure --enable-static --prefix $PSOPT_BUILD_DIR/.target --libdir=$PSOPT_BUILD_DIR/.target/lib64
    make
    cd ..
fi
cd ColPack-1.0.9
make install
cd ../..
