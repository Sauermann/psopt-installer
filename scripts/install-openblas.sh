#!/bin/bash

# scripts/install-openblas.sh
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

cd .packages
if [ ! -d OpenBLAS-0.2.8 ]; then
    tar xzvf ../.download/OpenBLAS-v0.2.8-x86_64.tar.gz
    cd OpenBLAS-0.2.8
    make
    cd ..
fi
cd OpenBLAS-0.2.8
make PREFIX=$PSOPT_BUILD_DIR/.target install
cd ../..
