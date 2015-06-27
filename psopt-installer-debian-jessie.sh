#!/bin/bash

echo "psopt-installer-debian-jessie.sh - PSOPT Installation Script for Debian Jessie"
echo ""
echo "Copyright (C) 2014-2015 Markus Sauermann"
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
echo "Last verified successful installation: 2015-06-27"
echo ""
echo "Make sure that the current user is in the groups sudo and staff."
echo "When you are asked for the sudo password, enter your password."
echo ""
read -s -p "Press enter to start the installation in your homedirectory."

# install needed packages
sudo apt-get install gfortran g++ libgd2-xpm-dev libpango1.0-dev unzip libf2c2-dev libblas-dev liblapack-dev libatlas-base-dev f2c libblas3gf liblapack3gf
# add directory for content
cd ~
mkdir packages
cd packages
# get Ipopt 3.9.3
wget http://www.coin-or.org/download/source/Ipopt/Ipopt-3.9.3.tgz
tar xzvf Ipopt-3.9.3.tgz
# Documentation for Ipopt Third Party modules:
# http://www.coin-or.org/Ipopt/documentation/node13.html
cd Ipopt-3.9.3/ThirdParty
# Blas
cd Blas
sed -i 's/ftp:/http:/g' get.Blas
./get.Blas
cd ..
# Lapack
cd Lapack
sed -i 's/ftp:/http:/g' get.Lapack
./get.Lapack
cd ..
# Metis
cd Metis
sed -i 's/metis\/metis/metis\/OLD\/metis/g' get.Metis
sed -i 's/metis-4\.0/metis-4\.0\.1/g' get.Metis
./get.Metis
# Patching is necessary. See http://www.math-linux.com/mathematics/Linear-Systems/How-to-patch-metis-4-0-error
wget http://www.math-linux.com/IMG/patch/metis-4.0.patch
patch -p0 < metis-4.0.patch
cd ..
# Mumps
cd Mumps
./get.Mumps
cd ..
# ASL
#cd ASL
#wget --recursive --include-directories=ampl/solvers http://www.netlib.org/ampl/solvers
#mv www.netlib.org/ampl/solvers .
#rm -rf www.netlib.org/
#sed -i 's/^rm/# rm/g' get.ASL
#sed -i 's/^tar /# tar/g' get.ASL
#sed -i 's/^$wgetcmd/# $wgetcmd/g' get.ASL
#cd ..
# Compile Ipopt
cd ..
# bugfix of http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=625018#10
sed -n 'H;${x;s/#include "IpReferenced.hpp"/#include <cstddef>\
\
&/;p;}' Ipopt/src/Common/IpSmartPtr.hpp > IpSmartPtr.hpp
mv IpSmartPtr.hpp Ipopt/src/Common/IpSmartPtr.hpp
sed -n 'H;${x;s/#include <list>/&\
#include <cstddef>/;p;}' Ipopt/src/Algorithm/LinearSolvers/IpTripletToCSRConverter.cpp > IpTripletToCSRConverter.cpp
mv IpTripletToCSRConverter.cpp Ipopt/src/Algorithm/LinearSolvers/IpTripletToCSRConverter.cpp
# create build directory
mkdir build
cd build
# start building
../configure --enable-static --prefix ~/Ipopt-3.9.3
make install
cd ../../..
# Adol-C
wget www.coin-or.org/download/source/ADOL-C/ADOL-C-2.1.12.tgz
tar xzfv ADOL-C-2.1.12.tgz
# with Colpack
cd ADOL-C-2.1.12/ThirdParty
wget http://cscapes.cs.purdue.edu/download/ColPack/ColPack-1.0.3.tar.gz
tar -xzvf ColPack-1.0.3.tar.gz
cd ColPack
make
cd ../..
# and Adol-C Compilation
# see http://list.coin-or.org/pipermail/adol-c/2012-March/000808.html
./configure --enable-sparse --enable-static
make
make install
cd ..
# PDFlib for Gnuplot
cd packages
wget http://www.pdflib.com/binaries/PDFlib/705/PDFlib-Lite-7.0.5p3.tar.gz
tar xzvf PDFlib-Lite-7.0.5p3.tar.gz
cd PDFlib-Lite-7.0.5p3
./configure --enable-static
make
make install
sudo ldconfig -v
cd ..
# Gnuplot
wget -O gnuplot-4.2.6.tar.gz http://sourceforge.net/projects/gnuplot/files/gnuplot/4.2.6/gnuplot-4.2.6.tar.gz/download
tar xzfv gnuplot-4.2.6.tar.gz
cd gnuplot-4.2.6
./configure
make
make install
cd ..
# SuiteSparse
wget http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-4.4.3.tar.gz
tar xzvf ../packages/SuiteSparse-4.4.3.tar.gz
tar xzvf ../packages/SuiteSparse-4.4.3.tar.gz
cd SuiteSparse
cd SuiteSparse_config
make library
make install
cd ../CXSparse
make library
make install
cd ../..
# getting PSOPT
wget http://psopt.googlecode.com/files/Psopt3.tgz
wget http://psopt.googlecode.com/files/patch_3.02.zip
wget http://www.stanford.edu/group/SOL/software/lusol/lusol.zip
unzip patch_3.02.zip
cd ..
tar xzvf packages/Psopt3.tgz
cp packages/patch_3.02/psopt.cxx Psopt3/PSOPT/src/
cd Psopt3
unzip ../packages/lusol.zip
# PSOPT makefile adjustment
sed -n 'H;${x;s/CXXFLAGS      = -O0 -g/& -I$(USERHOME)\/adolc_base\/include/;p;}' PSOPT/lib/Makefile > temp_file
mv temp_file PSOPT/lib/Makefile
sed -n 'H;${x;s/CXXFLAGS      = -O0 -g/& -I$(USERHOME)\/adolc_base\/include/;p;}' PSOPT/examples/Makefile_linux.inc > temp_file
mv temp_file PSOPT/examples/Makefile_linux.inc
sed -n 'H;${x;s/ADOLC_LIBS    = -ladolc/ADOLC_LIBS    = $(USERHOME)\/adolc_base\/lib64\/libadolc.a/;p;}' PSOPT/examples/Makefile_linux.inc > temp_file
mv temp_file PSOPT/examples/Makefile_linux.inc
sed -n 'H;${x;s/libcoinhsl.a/& $(IPOPTLIBDIR)\/ThirdParty\/libcoinmumps.a $(IPOPTLIBDIR)\/ThirdParty\/libcoinmetis.a -lpthread/;p;}' PSOPT/examples/Makefile_linux.inc > temp_file
mv temp_file PSOPT/examples/Makefile_linux.inc
sed -n 'H;${x;s/all: $(CXSPARSE_LIBS)/all:/;p;}' Makefile > temp_file
mv temp_file Makefile
sed -n 'H;${x;s/CXSPARSE=..\/..\/CXSparse/CXSPARSE=..\/..\/..\/packages\/SuiteSparse\/CXSparse/;p;}' dmatrix/examples/Makefile > temp_file
mv temp_file dmatrix/examples/Makefile
sed -n 'H;${x;s/CXSPARSE=..\/..\/..\/CXSparse/CXSPARSE=..\/..\/..\/..\/packages\/SuiteSparse\/CXSparse/;p;}' PSOPT/examples/Makefile_linux.inc > temp_file
mv temp_file PSOPT/examples/Makefile_linux.inc
sed -n 'H;${x;s/\/usr\/lib\/liblapack.a -llapack -lm/-llapack -lgfortran -lm/;p;}' PSOPT/examples/Makefile_linux.inc > temp_file
mv temp_file PSOPT/examples/Makefile_linux.inc
# Psopt Compilation
make all
echo "installation finished"
