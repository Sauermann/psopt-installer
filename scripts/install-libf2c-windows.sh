#!/bin/bash

# scripts/install-libf2c-windows.sh
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
source ./scripts/prescript.sh

# Download
psoptInstallerDownload libf2c.zip http://www.netlib.org/f2c/libf2c.zip

# Compile
cd .packages
if [ ! -d libf2c ]; then
    mkdir libf2c
    cd libf2c
    unzip ../../.download/libf2c.zip
    cp makefile.u Makefile
    make hadd
    sed -i -n 'H;${x;s/CC = cc/CC = gcc/;p;}' Makefile
    sed -i -n 'H;${x;s/a.out/a.exe/g;p;}' Makefile
    sed -i -n 'H;${x;s/CFLAGS = -O/& -DUSE_CLOCK/;p;}' Makefile
    make
    cd ..
fi

# Install
cd libf2c
export LIBDIR=$PSOPT_BUILD_DIR/.target/lib
make install
unset LIBDIR
cp f2c.h $PSOPT_BUILD_DIR/.target/include
cd ../..

# Reset
source ./scripts/postscript.sh
