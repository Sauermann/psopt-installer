#!/bin/bash

export PATH=".:/mingw/bin:/bin"

echo "wmpis.sh - Windows 7 MinGW-64 PSOPT Installation Script"
echo ""
echo "Copyright (C) 2014 Markus Sauermann"
echo ""
echo "This program comes with ABSOLUTELY NO WARRANTY."
echo "This is free software, and you are welcome to redistribute it"
echo "under certain conditions; see the filecontent for more information."

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see
# <http://www.gnu.org/licenses/>.

echo ""
read -s -p "Press enter to start the installation."

# add directory for content
cd /c
mkdir psopt
cd psopt
# Download packages
wget --no-check-certificate https://github.com/xianyi/OpenBLAS/archive/v0.2.8.tar.gz -O OpenBLAS-v0.2.8-x86_64.tar.gz
wget http://www.coin-or.org/download/source/Ipopt/Ipopt-3.9.3.tgz
wget http://www.math-linux.com/IMG/patch/metis-4.0.patch
wget http://www.coin-or.org/download/source/ADOL-C/ADOL-C-2.1.12.zip
wget http://cscapes.cs.purdue.edu/download/ColPack/ColPack-1.0.3.tar.gz
wget http://lrn.no-ip.info/packages/i686-w64-mingw/dlfcn-win32/r19-6/dlfcn-win32-r19-6-mingw_i686-src.tar.xz
wget http://www.netlib.org/f2c/libf2c.zip
wget http://psopt.googlecode.com/files/Psopt3.tgz
wget http://psopt.googlecode.com/files/patch_3.02.zip
wget http://www.cise.ufl.edu/research/sparse/SuiteSparse_config/UFconfig-3.6.1.tar.gz
wget http://www.cise.ufl.edu/research/sparse/CXSparse/versions/CXSparse-2.2.5.tar.gz
wget http://www.stanford.edu/group/SOL/software/lusol/lusol.zip

# OpenBLAS
tar xzvf OpenBLAS-v0.2.8-x86_64.tar.gz
cd OpenBLAS-0.2.8
make
make PREFIX=/c/psopt/bin-openblas-0.2.8 install
cd ..
# get Ipopt 3.9.3
tar xzvf Ipopt-3.9.3.tgz
# Documentation for Ipopt Third Party modules:
# http://www.coin-or.org/Ipopt/documentation/node13.html
cd Ipopt-3.9.3/ThirdParty
# Metis
cd Metis
sed -i 's/metis\/metis/metis\/OLD\/metis/g' get.Metis
sed -i 's/metis-4\.0/metis-4\.0\.1/g' get.Metis
./get.Metis
# Patching is necessary. See http://www.math-linux.com/mathematics/Linear-Systems/How-to-patch-metis-4-0-error
patch -p0 < ../../../metis-4.0.patch
cd ..
# Mumps
cd Mumps
./get.Mumps
cd ..
# bugfix of http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=625018#10
cd ..
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
../configure --enable-static --prefix /c/psopt/bin-Ipopt-3.9.3 -with-blas="-L/c/psopt/bin-openblas-0.2.8/lib -llibopenblas"
make install
cd ../..
# Adol-C
unzip ADOL-C-2.1.12.zip
# with Colpack
cd ADOL-C-2.1.12/ThirdParty
tar -xzvf ../../ColPack-1.0.3.tar.gz
cd ColPack
make
cd ../..
# and Adol-C Compilation
./configure --enable-sparse --enable-static --prefix /c/psopt/bin-adolc-2.1.12
cd ADOL-C
cp -r src adolc
cd src
make
make install
cd ../../..
# dlfcn
mkdir dlfcn
cd dlfcn
tar xJvf ../dlfcn-win32-r19-6-mingw_i686-src.tar.xz
export arch=WIN
sed -n 'H;${x;s/sha512sum/shasum/;p;}' pkgbuild.sh > temp_file
mv temp_file pkgbuild.sh
sed -n 'H;${x;s/do_fixinstall=1/do_fixinstall=0/;p;}' pkgbuild.sh > temp_file
mv temp_file pkgbuild.sh
sed -n 'H;${x;s/do_pack=1/do_pack=0/;p;}' pkgbuild.sh > temp_file
mv temp_file pkgbuild.sh
sed -n 'H;${x;s/do_clean=1/do_clean=0/;p;}' pkgbuild.sh > temp_file
mv temp_file pkgbuild.sh
chmod a+x pkgbuild.sh
./pkgbuild.sh
cd ..
unset arch
# libf2c
mkdir libf2c
cd libf2c
unzip ../libf2c.zip
cp makefile.u Makefile
make hadd
sed -n 'H;${x;s/CC = cc/CC = gcc/;p;}' Makefile > temp_file
mv temp_file Makefile
sed -n 'H;${x;s/a.out/a.exe/g;p;}' Makefile > temp_file
mv temp_file Makefile
sed -n 'H;${x;s/CFLAGS = -O/& -DUSE_CLOCK/;p;}' Makefile > temp_file
mv temp_file Makefile
make
cd ..
# PSOPT
unzip patch_3.02.zip
tar xzvf Psopt3.tgz
cp patch_3.02/psopt.cxx Psopt3/PSOPT/src/
cd Psopt3
tar xzvf ../UFconfig-3.6.1.tar.gz
tar xzvf ../CXSparse-2.2.5.tar.gz
unzip ../lusol.zip
# PSOPT makefile adjustment
sed -i -n 'H;${x;s/CC = cc/CC = gcc/;p;}' UFconfig/UFconfig.mk
sed -i -n 'H;${x;s/\/usr\/bin\///g;p;}' dmatrix/lib/Makefile
sed -i -n 'H;${x;s/I = -I./& -I\/c\/psopt\/dlfcn\/inst\/mingw\/include/;p;}' Makefile.lusol
sed -i -n 'H;${x;s/\/usr\/bin\///g;p;}' PSOPT/lib/Makefile
sed -i -n 'H;${x;s/USERHOME      = \/home\/$(shell whoami)/USERHOME = \/c\/psopt/;p;}' PSOPT/lib/Makefile
sed -i -n 'H;${x;s/Ipopt-3.9.3/bin-&/;p;}' PSOPT/lib/Makefile
sed -i -n 'H;${x;s/CXXFLAGS      = -O0 -g/& -I$(USERHOME)\/bin-adolc-2.1.12\/include -U WIN32/;p;}' PSOPT/lib/Makefile
sed -i -n 'H;${x;s/dmatrix_examples bioreactor/bioreactor/;p;}' Makefile
sed -i -n 'H;${x;s/\/usr\/bin\///g;p;}' PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s/CXXFLAGS      = -O0 -g/& -I$(USERHOME)\/bin-adolc-2.1.12\/include/;p;}' PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s/USERHOME      = \/home\/$(shell whoami)/USERHOME = \/c\/psopt/;p;}' PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s/ -ldl//;p;}' PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s/Ipopt-3.9.3/bin-&/;p;}' PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s/\/usr\/lib\/libf2c.a/\/c\/psopt\/libf2c\/libf2c.a/g;p;}' PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s/ADOLC_LIBS    = -ladolc/ADOLC_LIBS    = $(USERHOME)\/bin-adolc-2.1.12\/lib64\/libadolc.a/;p;}' PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s/-ldl/$(USERHOME)\/dlfcn\/inst\/mingw\/lib\/libdl.a/;p;}' PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s/\/usr\/lib\/liblapack.a//;p;}' PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s/gcc_s/gcc/;p;}' PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s/libcoinhsl.a/& $(IPOPTLIBDIR)\/ThirdParty\/libcoinmumps.a $(USERHOME)\/bin-openblas-0.2.8\/lib\/libopenblas.a \/mingw\/bin\/libgfortran_64-3.dll $(IPOPTLIBDIR)\/ThirdParty\/libcoinmetis.a/;p;}' PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s/-lblas  -llapack//;p;}' PSOPT/examples/Makefile_linux.inc
# Compilation
make all
echo "installation finished"

# # zlib for libpng
# wget http://zlib.net/zlib-1.2.8.tar.xz
# tar xJvf zlib-1.2.8.tar.xz
# cd zlib-1.2.8
# export DESTDIR=/c/psopt/bin-zlib-1.2.8/
# export BINARY_PATH=bin
# export LIBRARY_PATH=lib
# export INCLUDE_PATH=include
# make -fwin32/Makefile.gcc install
# unset DESTDIR
# unset BINARY_PATH
# unset LIBRARY_PATH
# unset INCLUDE_PATH
# cd ..
# # libpng for libgd
# wget -O libpng-1.6.8.tar.xz/ http://sourceforge.net/projects/libpng/files/libpng16/1.6.8/libpng-1.6.8.tar.xz/download
# tar xJvf libpng-1.6.8.tar.xz
# cd libpng-1.6.8
# export CPPFLAGS='-I/c/psopt/bin-zlib-1.2.8/include'
# export LDFLAGS='-L/c/psopt/bin-zlib-1.2.8/lib'
# ./configure --enable-static --with-zlib-prefix=/c/psopt/bin-zlib-1.2.8 --prefix=/c/psopt/bin-libpng-1.6.8
# make
# make install
# unset CPPFLAGS
# unset LDFLAGS
# # libgd for gnuplot
# wget --no-check-certificate https://bitbucket.org/libgd/gd-libgd/downloads/libgd-2.1.0.tar.xz
# tar xJvf libgd-2.1.0.tar.xz
# cd libgd-2.1.0
# export LDFLAGS='-L/c/psopt/bin-zlib-1.2.8/lib'
# export CPPFLAGS='-I/c/psopt/bin-zlib-1.2.8/include'
# ./configure  --with-zlib=/c/psopt/bin-zlib-1.2.8 --with-png=/c/psopt/bin-libpng-1.6.8 --enable-shared --enable-static --prefix=/c/psopt/bin-libgd-2.1.0
# make
# unset CPPFLAGS
# unset LDFLAGS
