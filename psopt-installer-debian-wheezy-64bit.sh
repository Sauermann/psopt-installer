#!/bin/sh

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


# install needed packages
# libgd2-xpm-dev libpango1.0-dev  libblas-dev liblapack-dev libatlas-base-dev f2c libblas3gf liblapack3gf
sudo apt-get install gfortran g++ unzip dos2unix libf2c2-dev
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


unset psoptInstallerDownload

# Apply local patches
dos2unix PSOPT/src/psopt.cxx
patch --ignore-whitespace -p1 < ../../psopt-installer-master/patches/psopt-bugfix-static-variable.patch
patch -p1 < ../../psopt-installer-master/patches/psopt-c++0x-windows.patch
patch --binary -p1 < ../../psopt-installer-master/patches/psopt-lambdafunction-windows.patch
patch -p1 < ../../psopt-installer-master/patches/psopt-ipopt-3-11-7-compatibility.patch

#patch -p1 < ../../psopt-installer-master/patches/psopt-gnuplot.patch
# PSOPT static library
sed -i -n 'H;${x;s#-I$(DMATRIXDIR)/include##g;p;}' PSOPT/lib/Makefile
sed -i -n 'H;${x;s#-I$(CXSPARSE)/Include -I$(LUSOL) -I$(IPOPTINCDIR)#-I'"$PSOPT_BUILD_DIR"'/.target/include -I'"$PSOPT_BUILD_DIR"'/.target/include/coin#g;p;}' PSOPT/lib/Makefile
make ./PSOPT/lib/libpsopt.a
cp PSOPT/lib/libpsopt.a $PSOPT_BUILD_DIR/.target/lib
cp PSOPT/src/psopt.h $PSOPT_BUILD_DIR/.target/include
# PSOPT Examples
sed -n 'H;${x;s#CXXFLAGS      = -O0 -g#& -I$(PSOPT_BUILD_DIR)/.target/include#;p;}' PSOPT/examples/Makefile_linux.inc > temp_file
mv temp_file PSOPT/examples/Makefile_linux.inc
sed -n 'H;${x;s#ADOLC_LIBS    = -ladolc#ADOLC_LIBS    = $(PSOPT_BUILD_DIR)/.target/lib64/libadolc.a#;p;}' PSOPT/examples/Makefile_linux.inc > temp_file
mv temp_file PSOPT/examples/Makefile_linux.inc
sed -n 'H;${x;s#libcoinhsl.a#& $(PSOPT_BUILD_DIR)/.target/lib/libcoinmumps.a $(PSOPT_BUILD_DIR)/.target/lib/libcoinmetis.a -lpthread/#p;}' PSOPT/examples/Makefile_linux.inc > temp_file
mv temp_file PSOPT/examples/Makefile_linux.inc


#sed -i -n 'H;${x;s/$(CXSPARSE_LIBS) $(DMATRIX_LIBS) $(LUSOL_LIBS) $(PSOPT_LIBS) dmatrix_examples //;p;}' Makefile
#sed -i -n 'H;${x;s#-I$(DMATRIXDIR)/include  -I$(PSOPTSRCDIR)#-I'"$PSOPT_BUILD_DIR"'/.target/include#;p;}' PSOPT/examples/Makefile_linux.inc
#sed -i -n 'H;${x;s#DMATRIX_LIBS  =#DMATRIX_LIBS_UNUSED  =#;p;}' PSOPT/examples/Makefile_linux.inc
#sed -i -n 'H;${x;s#PSOPT_LIBS    =#PSOPT_LIBS_UNUSED    =#;p;}' PSOPT/examples/Makefile_linux.inc
#sed -i -n 'H;${x;s#SPARSE_LIBS   =#SPARSE_LIBS_UNUSED   =#;p;}' PSOPT/examples/Makefile_linux.inc
#sed -i -n 'H;${x;s#FLIBS    #FLIBS_UNUSED    #g;p;}' PSOPT/examples/Makefile_linux.inc
#sed -i -n 'H;${x;s#ALL_LIBRARIES = $(PSOPT_LIBS) $(DMATRIX_LIBS)  $(FLIBS) $(SPARSE_LIBS) $(IPOPT_LIBS)  $(ADOLC_LIBS)#ALL_LIBRARIES = -L'"$PSOPT_BUILD_DIR/.target/lib -lcombinedpsopt -lpthread -ldl#;p;}" PSOPT/examples/Makefile_linux.inc
#sed -i -n 'H;${x;s#EXAMPLESDIR = .#&\
#LIBDIR = '"$PSOPT_BUILD_DIR"'/.target/lib#;p;}' PSOPT/examples/Makefile_linux.inc


# Compilation
if [ ! -f ../../NO_PSOPT_EXAMPLES ]; then
    make all
fi




# add directory for content

# Psopt Compilation
make all
echo "installation finished"
