#!/bin/bash

# scripts/install-lusol.sh
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
if [ ! -d lusol ]; then
    unzip ../.download/lusol.zip
    cd lusol/csrc
    tar xOzvf ../../../.download/Psopt3.tgz ./Psopt3/Makefile.lusol > Makefile
    sed -i -n 'H;${x;s#I = -I.#& -I'"$PSOPT_BUILD_DIR"'/.target/include#;p;}' Makefile
    make
    cd ../..
fi
cd lusol/csrc
cp liblusol.a $PSOPT_BUILD_DIR/.target/lib
cp *.h $PSOPT_BUILD_DIR/.target/include
cd ../../..
