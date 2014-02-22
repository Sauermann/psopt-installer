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
    sed -i -n 'H;${x;s|#define abs(x) ((x) >= 0 ? (x) : -(x))|//&|;p;}' f2c.h
    sed -i -n 'H;${x;s|#define min(a,b) ((a) <= (b) ? (a) : (b))|//&|;p;}' f2c.h
    sed -i -n 'H;${x;s|#define max(a,b) ((a) >= (b) ? (a) : (b))|//&|;p;}' f2c.h
    make
    cd ..
fi
cd libf2c
export LIBDIR=$PSOPT_BUILD_DIR/.target/lib
make install
unset LIBDIR
cp f2c.h $PSOPT_BUILD_DIR/.target/include
cd ../..
