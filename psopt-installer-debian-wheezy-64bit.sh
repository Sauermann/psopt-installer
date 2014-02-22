#!/bin/bash

echo "psopt-installer-debian-wheezy-64bit.sh -"
echo "PSOPT Installation Script for Debian Wheezy"
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
read -s -p "Press enter to start the installation in the current directory."
echo ""

# install needed packages
# libgd2-xpm-dev libpango1.0-dev  libblas-dev liblapack-dev libatlas-base-dev f2c libblas3gf liblapack3gf
sudo apt-get install gfortran g++ unzip dos2unix libf2c2-dev gnuplot-x11
# Build Directory
export PSOPT_BUILD_DIR=$PWD

# download script
psoptInstallerDownload()
{
    if [ ! -f .download/$1 ]; then
        wget -O .download/$1 --no-check-certificate $2
    fi;
}
export -f psoptInstallerDownload
# Dir Creation
mkdir -p .packages
mkdir -p .download
mkdir -p .target/lib
mkdir -p .target/include

# Installation Scripts
./scripts/install-openblas.sh
./scripts/install-scotch-linux.sh
./scripts/install-mumps.sh
./scripts/install-ipopt.sh
./scripts/install-colpack-linux.sh
./scripts/install-adolc.sh
./scripts/install-ufconfig-linux.sh
./scripts/install-cxsparse.sh
./scripts/install-lusol.sh
./scripts/install-dmatrix-psopt-linux.sh
./scripts/compile-psopt-examples-linux.sh
./scripts/create-maindir-example-linux.sh
#./scripts/install-modern-psopt-interface.sh

unset PSOPT_BUILD_DIR
unset psoptInstallerDownload
echo ""
echo "installation finished"
