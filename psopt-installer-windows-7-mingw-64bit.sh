#!/bin/bash

echo ""
echo "psopt-installer-windows-7-mingw-64bit.sh - "
echo "PSOPT Installation Script for Windows 7 MinGW-64"
echo ""
echo "Copyright (C) 2014 Markus Sauermann"
echo ""
echo "This program comes with ABSOLUTELY NO WARRANTY."
echo "This is free software, and you are welcome to redistribute it"
echo "under certain conditions; see the filecontent for more information."

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

echo ""
read -s -p "Press enter to start the installation in the CURRENT DIRECTORY."
echo ""

# Build Directory
export PSOPT_BUILD_DIR=$PWD
# Download packages

psoptInstallerDownload()
{
    if [ ! -f .download/$1 ]; then
        wget -O .download/$1 --no-check-certificate $2
    fi;
}
export -f psoptInstallerDownload

# Download Dependency Packages
mkdir -p .packages
./scripts/install-openblas-windows.sh
./scripts/install-scotch.sh
./scripts/install-mumps.sh
./scripts/install-ipopt.sh
./scripts/install-colpack-windows.sh
./scripts/install-adolc.sh
./scripts/install-dlfcn-windows.sh
./scripts/install-libf2c-windows.sh
./scripts/install-ufconfig.sh
./scripts/install-cxsparse.sh
./scripts/install-lusol.sh
./scripts/install-dmatrix-psopt.sh
./scripts/create-combined-static-library-windows.sh
./scripts/compile-psopt-examples.sh
./scripts/create-maindir-example.sh
./scripts/install-modern-psopt-interface.sh
unset PSOPT_BUILD_DIR
echo ""
echo "installation finished"
