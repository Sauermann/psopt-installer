#!/bin/bash

# scripts/compile-psopt-examples-linux.sh
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

cd .packages/Psopt3
# Adjust Makefiles
patch -p1 < $PSOPT_BUILD_DIR/patches/psopt-examples-makefile-linux.patch
sed -i -n 'H;${x;s#[$][(]PSOPT_BUILD_DIR[)]#'"$PSOPT_BUILD_DIR"'#g;p;}' PSOPT/examples/Makefile_linux.inc
# Compilation
if [ ! -f ../../NO_PSOPT_EXAMPLES ]; then
    make all
fi
cd ../..
