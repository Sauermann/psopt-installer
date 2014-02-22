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
echo "Make sure that the current user is in the group sudo."
echo ""
read -s -p "Press enter to start the installation."


# install needed packages
# libgd2-xpm-dev libpango1.0-dev  libblas-dev liblapack-dev libatlas-base-dev f2c libblas3gf liblapack3gf
sudo apt-get install gfortran g++ libopenblas-dev unzip dos2unix libf2c2-dev
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
cd .packages
# Ipopt 3.11.7
if [ ! -d Ipopt-3.11.7 ]; then
    tar xzvf ../.download/Ipopt-3.11.7.tgz
    # Documentation for Ipopt Third Party modules:
    # http://www.coin-or.org/Ipopt/documentation/node13.html
    cd Ipopt-3.11.7/ThirdParty
    # Metis
    cd Metis
    ./get.Metis
    cd ..
    # Mumps
    cd Mumps
    ./get.Mumps
    cd ..
    # create build directory
    cd ..
    mkdir build
    cd build
    # start building
    ../configure --enable-static --prefix=$PSOPT_BUILD_DIR/.target --with-blas="-L$PSOPT_BUILD_DIR/.target/lib -lblas"
    make
    cd ../..
fi
# install
cd Ipopt-3.11.7/build
make install
cd ../..
# Adol-C
if [ ! -d ADOL-C-2.1.12 ]; then
    unzip ../.download/ADOL-C-2.1.12.zip
    # with Colpack
    cd ADOL-C-2.1.12/ThirdParty
    tar -xzvf ../../../.download/ColPack-1.0.3.tar.gz
    cd ColPack
    make
    cd ../..
    # and Adol-C Compilation
    ./configure --enable-sparse --enable-static --enable-shared --prefix $PSOPT_BUILD_DIR/.target
    make
    cd ..
fi
cd ADOL-C-2.1.12
make install
cd ..
# UFconfig
if [ ! -d UFconfig ]; then
    tar xzvf ../.download/UFconfig-3.6.1.tar.gz
    cd UFconfig
    sed -i -n 'H;${x;s/CC = cc/CC = gcc/;p;}' UFconfig.mk
    sed -i -n 'H;${x;s#/usr/local#'"$PSOPT_BUILD_DIR"'/.target#g;p;}' UFconfig.mk
    sed -i -n 'H;${x;s#CFLAGS = -O3 -fexceptions#& -fPIC#g;p;}' UFconfig.mk
    make
    cd ..
fi
cd UFconfig
make install
cd ..
# CXSparse
if [ ! -d CXSparse ]; then
    tar xzvf ../.download/CXSparse-2.2.5.tar.gz
    cd CXSparse
    make library
    cd ..
fi
cd CXSparse
make install
cd ..
# Unpack PSOPT (makefile needed for lusol)
tar xzvf ../.download/Psopt3.tgz
# lusol
unzip ../.download/lusol.zip
cp Psopt3/Makefile.lusol lusol/csrc/Makefile
cd lusol/csrc
sed -i -n 'H;${x;s#I = -I.#& -I'"$PSOPT_BUILD_DIR"'/.target/include#;p;}' Makefile
make
cp liblusol.a $PSOPT_BUILD_DIR/.target/lib
cp *.h $PSOPT_BUILD_DIR/.target/include
cd ../..
# DMatrix
cd Psopt3/dmatrix/lib
sed -i -n 'H;${x;s#-I$(CXSPARSE)/Include -I$(LUSOL) -I$(IPOPTINCDIR)#-I'"$PSOPT_BUILD_DIR"'/.target/include#g;p;}' Makefile
make
cp libdmatrix.a $PSOPT_BUILD_DIR/.target/lib
cd ..
cp include/dmatrixv.h $PSOPT_BUILD_DIR/.target/include
cd ..
# PSOPT patching to new release
unzip ../../.download/patch_3.02.zip
cp patch_3.02/psopt.cxx PSOPT/src/
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
