#!/bin/bash

echo ""
echo "wmpis.sh - PSOPT Installation Script for Windows 7 MinGW-64"
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

# hide most windows paths
export ORIGINAL_PATH=$PATH
export PATH=".:/mingw/bin:/bin:/c/Windows/System32"
# Build Directory
export PSOPT_BUILD_DIR=$PWD
# Download packages
mkdir .download
cd .download
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
cd ..
# OpenBLAS
mkdir .packages
cd .packages
tar xzvf ../.download/OpenBLAS-v0.2.8-x86_64.tar.gz
cd OpenBLAS-0.2.8
make
make PREFIX=$PSOPT_BUILD_DIR/.target install
cd ..
# Ipopt 3.9.3
tar xzvf ../.download/Ipopt-3.9.3.tgz
# Documentation for Ipopt Third Party modules:
# http://www.coin-or.org/Ipopt/documentation/node13.html
cd Ipopt-3.9.3/ThirdParty
# Metis
cd Metis
sed -i 's#metis/metis#metis/OLD/metis#g' get.Metis
sed -i 's#metis-4\.0#metis-4\.0\.1#g' get.Metis
./get.Metis
# Patching is necessary. See http://www.math-linux.com/mathematics/Linear-Systems/How-to-patch-metis-4-0-error
patch -p0 < ../../../../.download/metis-4.0.patch
cd ..
# Mumps
cd Mumps
./get.Mumps
cd ..
# bugfix of http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=625018#10
cd ..
sed -i -n 'H;${x;s/#include "IpReferenced.hpp"/#include <cstddef>\
\
&/;p;}' Ipopt/src/Common/IpSmartPtr.hpp
sed -i -n 'H;${x;s/#include <list>/&\
#include <cstddef>/;p;}' Ipopt/src/Algorithm/LinearSolvers/IpTripletToCSRConverter.cpp
# create build directory
mkdir build
cd build
# start building
../configure --enable-static --prefix $PSOPT_BUILD_DIR/.target -with-blas="-L$PSOPT_BUILD_DIR/.target/lib -llibopenblas"
make install
cd ../..
# Adol-C
unzip ../.download/ADOL-C-2.1.12.zip
# with Colpack
cd ADOL-C-2.1.12/ThirdParty
tar -xzvf ../../../.download/ColPack-1.0.3.tar.gz
cd ColPack
make
cd ../..
# and Adol-C Compilation
./configure --enable-sparse --enable-static --prefix $PSOPT_BUILD_DIR/.target
cd ADOL-C
cp -r src adolc
cd src
make
make install
cd ../../..
# dlfcn
mkdir dlfcn-19-6
cd dlfcn-19-6
tar xJvf ../../.download/dlfcn-win32-r19-6-mingw_i686-src.tar.xz
sed -i -n 'H;${x;s/sha512sum/shasum/;p;}' pkgbuild.sh
sed -i -n 'H;${x;s/do_fixinstall=1/do_fixinstall=0/;p;}' pkgbuild.sh
sed -i -n 'H;${x;s/do_pack=1/do_pack=0/;p;}' pkgbuild.sh
sed -i -n 'H;${x;s/do_clean=1/do_clean=0/;p;}' pkgbuild.sh
sed -i -n 'H;${x;s#instdir=${pkgbuilddir}/inst#instdir=$PSOPT_BUILD_DIR/.target#;p;}' pkgbuild.sh
sed -i -n 'H;${x;s/rm -rf ${blddir} ${instdir}/rm -rf ${blddir}/g;p;}' pkgbuild.sh
sed -i -n 'H;${x;s#prefix=/mingw#prefix=#;p;}' pkgbuild.sh
export arch=WIN
./pkgbuild.sh
unset arch
cd ..
# libf2c
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
export LIBDIR=$PSOPT_BUILD_DIR/.target/lib
make install
unset LIBDIR
cp f2c.h $PSOPT_BUILD_DIR/.target/include
cd ..
# UFconfig
tar xzvf ../.download/UFconfig-3.6.1.tar.gz
cd UFconfig
sed -i -n 'H;${x;s/CC = cc/CC = gcc/;p;}' UFconfig.mk
sed -i -n 'H;${x;s#/usr/local#'"$PSOPT_BUILD_DIR"'/.target#g;p;}' UFconfig.mk
make
make install
cd ..
# CXSparse
tar xzvf ../.download/CXSparse-2.2.5.tar.gz
cd CXSparse
make library
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
sed -i -n 'H;${x;s#/usr/bin/##g;p;}' Makefile
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
patch -p1 < ../../psopt-installer-master/patches/psopt-gnuplot-windows.patch
patch -p1 < ../../psopt-installer-master/patches/psopt-c++0x-windows.patch
patch -p1 < ../../psopt-installer-master/patches/psopt-lambdafunction-windows.patch
patch -p1 < ../../psopt-installer-master/patches/psopt-bugfix-static-variable.patch
# PSOPT static library
sed -i -n 'H;${x;s#/usr/bin/##g;p;}' PSOPT/lib/Makefile
sed -i -n 'H;${x;s#-I$(DMATRIXDIR)/include#-U WIN32#g;p;}' PSOPT/lib/Makefile
sed -i -n 'H;${x;s#-I$(CXSPARSE)/Include -I$(LUSOL) -I$(IPOPTINCDIR)#-I'"$PSOPT_BUILD_DIR"'/.target/include -I'"$PSOPT_BUILD_DIR"'/.target/include/coin#g;p;}' PSOPT/lib/Makefile
make ./PSOPT/lib/libpsopt.a
cp PSOPT/lib/libpsopt.a $PSOPT_BUILD_DIR/.target/lib
cp PSOPT/src/psopt.h $PSOPT_BUILD_DIR/.target/include
# PSOPT combined shared library
# dependencies:
# psopt -> dmatrix
# psopt -> adolc
# dmatrix -> lusol
# dmatrix -> cxsparse
# psopt -> openblas
# dmatrix -> openblas
# lusol -> ipopt
# lusol -> dl
# openblas -> gfortran
# ipopt -> mumps
# ipopt -> openblas
# mumps -> metis
# mumps -> openblas
chmod a+w PSOPT/lib/Makefile
echo -e "
MERGE_LIBS= -L$PSOPT_BUILD_DIR/.target/lib -L$PSOPT_BUILD_DIR/.target/lib/coin -L$PSOPT_BUILD_DIR/.target/lib/coin/ThirdParty -L$PSOPT_BUILD_DIR/.target/lib64 $< -ldmatrix -lcxsparse -ladolc -llusol -lipopt -lcoinmumps -lopenblas -lcoinmetis -lgfortran -ldl

libcombinedpsopt.so: \$(PSOPTSRCDIR)/psopt.o
\t\$(CXX) -shared \$(CXXFLAGS) \$(MERGE_LIBS) -o \$@
" >> PSOPT/lib/Makefile
cd PSOPT/lib
make libcombinedpsopt.so
cp libcombinedpsopt.so $PSOPT_BUILD_DIR/.target/lib/
cd ../..
# PSOPT combined static library
cd ../../.target/lib
cp /mingw/lib/gcc/x86_64-w64-mingw32/4.8.1/libgfortran.a .
echo "CREATE libcombinedpsopt.a
ADDLIB libpsopt.a
ADDLIB libdmatrix.a
ADDLIB libcxsparse.a
ADDLIB ../lib64/libadolc.a
ADDLIB liblusol.a
ADDLIB coin/libipopt.a
ADDLIB coin/ThirdParty/libcoinmumps.a
ADDLIB libopenblas.a
ADDLIB coin/ThirdParty/libcoinmetis.a
ADDLIB libgfortran.a
ADDLIB libdl.a
SAVE
END" | ar -M
rm libgfortran.a
cd ../../.packages/Psopt3
# PSOPT Examples
sed -i -n 'H;${x;s#"obstacle_xy.pdf");#&\
\
    system("explorer.exe obstacle_xy.pdf");#;p;}' PSOPT/examples/obstacle/obstacle.cxx
sed -i -n 'H;${x;s/$(CXSPARSE_LIBS) $(DMATRIX_LIBS) $(LUSOL_LIBS) $(PSOPT_LIBS) dmatrix_examples //;p;}' Makefile
sed -i -n 'H;${x;s#/usr/bin/##g;p;}' PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s#-I$(DMATRIXDIR)/include  -I$(PSOPTSRCDIR)#-I'"$PSOPT_BUILD_DIR"'/.target/include#;p;}' PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s#DMATRIX_LIBS  =#DMATRIX_LIBS_UNUSED  =#;p;}' PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s#PSOPT_LIBS    =#PSOPT_LIBS_UNUSED    =#;p;}' PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s#SPARSE_LIBS   =#SPARSE_LIBS_UNUSED   =#;p;}' PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s#FLIBS    #FLIBS_UNUSED    #g;p;}' PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s#ALL_LIBRARIES = $(PSOPT_LIBS) $(DMATRIX_LIBS)  $(FLIBS) $(SPARSE_LIBS) $(IPOPT_LIBS)  $(ADOLC_LIBS)#ALL_LIBRARIES = -L'"$PSOPT_BUILD_DIR/.target/lib -lcombinedpsopt#;p;}" PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s/gcc_s/gcc/;p;}' PSOPT/examples/Makefile_linux.inc
sed -i -n 'H;${x;s#EXAMPLESDIR = .#&\
LIBDIR = '"$PSOPT_BUILD_DIR"'/.target/lib#;p;}' PSOPT/examples/Makefile_linux.inc
# Compilation
export PATH=$ORIGINAL_PATH
unset ORIGINAL_PATH
make all
# Create Example
cd ../..
mkdir obstacle
cp .packages/Psopt3/PSOPT/examples/obstacle/obstacle.cxx obstacle
echo "# name of the executable
TARGET = obstacle
# Put the object files of depencencies here and define make-procedures
# in this file
OBJECT_DEPS =
# Put extra compilerflags here
CXXFLAGSEXTRA =
# include default PSOPT make-rules for the project
include ../Makefile_include.mk

#this is called from clean
projectclean:

# put additional make recepies for further objects here
" > obstacle/Makefile
echo -e 'CXX       = g++
INSTALLDIR = $(dir $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))
CXXFLAGS  = -O0 -g -std=c++0x -DLAPACK -DUNIX -DSPARSE_MATRIX -DUSE_IPOPT -fomit-frame-pointer -pipe -DNDEBUG -pedantic-errors -Wall -DHAVE_MALLOC

INCLUDES  = -I$(INSTALLDIR).target/include
#LINKFLAGS = -fPIC -L$(INSTALLDIR).target/lib -L$(INSTALLDIR).target/lib/coin -L$(INSTALLDIR).target/lib/coin/ThirdParty -L$(INSTALLDIR).target/lib64
#LIBRARIES = -lpsopt -ldmatrix -lcxsparse -ladolc -llusol -lipopt -lcoinmumps -lopenblas -lcoinmetis -lgfortran -ldl -lm -lgcc
LIBRARIES = -fPIC -L$(INSTALLDIR).target/lib -lcombinedpsopt -lm -lgcc

$(TARGET): $(TARGET).o $(OBJECT_DEPS)
\t$(CXX) $(CXXFLAGS) $(CXXFLAGSEXTRA) $(LINKFLAGS) $^ -o $@ $(LIBRARIES)

$(TARGET).o: $(TARGET).cxx
\t$(CXX) -c $(CXXFLAGS) $(CXXFLAGSEXTRA) $(INCLUDES) $< -o $@

clean: projectclean
\trm -f *.o $(TARGET) $(TARGET).exe

psoptclean: clean
\trm -f $(TARGET).txt *.dat mesh_statistics* *.out psopt_solution_*.txt gnuplot.scp
' > Makefile_include.mk
cd obstacle
make
cd ..
echo ""
echo "installation finished"
