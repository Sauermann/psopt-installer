#!/bin/bash

# scripts/install-ipopt.sh
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
if [ ! -d Ipopt-3.11.7 ]; then
    tar xzvf ../.download/Ipopt-3.11.7.tgz
    # bugfix for http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=625018#10
    cd Ipopt-3.11.7
    # create build directory
    mkdir -p build
    cd build
    # start building
    ../configure --enable-static --prefix $PSOPT_BUILD_DIR/.target -with-blas="-L$PSOPT_BUILD_DIR/.target/lib -lopenblas" --with-mumps-lib="-L$PSOPT_BUILD_DIR/.target/lib -ldmumps -lmumps_common -lpord -lmpiseq" --with-mumps-incdir="$PSOPT_BUILD_DIR/.target/include"
    make
    cd ../..
fi
# install
cd Ipopt-3.11.7/build
make install
cd ../../..
