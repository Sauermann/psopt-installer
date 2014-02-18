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

wmpisdl()
{
    if [ ! -f $1 ]; then
        wget -O $1 --no-check-certificate $2
    fi;
}
# hide most windows paths
export ORIGINAL_PATH=$PATH
export PATH=".:/mingw/bin:/bin:/c/Windows/System32"
# Build Directory
export PSOPT_BUILD_DIR=$PWD
# Download packages
mkdir -p .download
cd .download
wmpisdl OpenBLAS-v0.2.8-x86_64.tar.gz https://github.com/xianyi/OpenBLAS/archive/v0.2.8.tar.gz
wmpisdl Ipopt-3.11.7.tgz http://www.coin-or.org/download/source/Ipopt/Ipopt-3.11.7.tgz
wmpisdl ADOL-C-2.4.1.tgz http://www.coin-or.org/download/source/ADOL-C/ADOL-C-2.4.1.tgz
wmpisdl ColPack-1.0.9.tar.gz http://cscapes.cs.purdue.edu/download/ColPack/ColPack-1.0.9.tar.gz
wmpisdl dlfcn-win32-r19-6-mingw_i686-src.tar.xz http://lrn.no-ip.info/packages/i686-w64-mingw/dlfcn-win32/r19-6/dlfcn-win32-r19-6-mingw_i686-src.tar.xz
wmpisdl libf2c.zip http://www.netlib.org/f2c/libf2c.zip
wmpisdl Psopt3.tgz http://psopt.googlecode.com/files/Psopt3.tgz
wmpisdl patch_3.02.zip http://psopt.googlecode.com/files/patch_3.02.zip
wmpisdl UFconfig-3.6.1.tar.gz http://www.cise.ufl.edu/research/sparse/SuiteSparse_config/UFconfig-3.6.1.tar.gz
wmpisdl CXSparse-2.2.5.tar.gz http://www.cise.ufl.edu/research/sparse/CXSparse/versions/CXSparse-2.2.5.tar.gz
wmpisdl lusol.zip http://www.stanford.edu/group/SOL/software/lusol/lusol.zip
wmpisdl modern-psopt-interface.zip https://github.com/Sauermann/modern-psopt-interface/archive/master.zip
wmpisdl MUMPS_4.9.2.tar.gz http://mumps.enseeiht.fr/MUMPS_4.9.2.tar.gz
wmpisdl scotch_6.0.0_esmumps.tar.gz https://gforge.inria.fr/frs/download.php/31832/scotch_6.0.0_esmumps.tar.gz
cd ..
# Dircreation
mkdir -p .packages
cd .packages
# OpenBLAS
if [ ! -d OpenBLAS-0.2.8 ]; then
    tar xzvf ../.download/OpenBLAS-v0.2.8-x86_64.tar.gz
    cd OpenBLAS-0.2.8
    make
    cd ..
fi
cd OpenBLAS-0.2.8
make PREFIX=$PSOPT_BUILD_DIR/.target install
cd ..
# Scotch
if [ ! -d scotch_6.0.0_esmumps ]; then
    tar xzvf ../.download/scotch_6.0.0_esmumps.tar.gz
    cd scotch_6.0.0_esmumps
    patch -p1 < $PSOPT_BUILD_DIR/patches/scotch-mingw-64.patch
    cd src
    make esmumps
    cd ../..
fi
cd scotch_6.0.0_esmumps
cp include/scotch.h include scotchf.h $PSOPT_BUILD_DIR/.target/include
cp lib/*.a $PSOPT_BUILD_DIR/.target/lib
cd ..
# Mumps
if [ ! -d MUMPS_4.9.2 ]; then
    tar xzvf ../.download/MUMPS_4.9.2.tar.gz
    cd MUMPS_4.9.2
    cp Make.inc/Makefile.gfortran.SEQ Makefile.inc
    sed -i 's|#SCOTCHDIR  = ${HOME}/scotch_5.1_esmumps|SCOTCHDIR  = $(PSOPT_BUILD_DIR)/.target/lib|' Makefile.inc
    sed -i 's|#LSCOTCH    = -L$(SCOTCHDIR)/lib -lesmumps -lscotch -lscotcherr|LSCOTCH    = -L$(SCOTCHDIR) -lesmumps -lscotch -lscotcherr|' Makefile.inc
    sed -i 's#ORDERINGSF  = -Dpord#& -Dscotch#' Makefile.inc
    sed -i 's#-lblas#-lopenblas#' Makefile.inc
    make
    cd ..
fi
cd MUMPS_4.9.2
cp lib/*.a ../../.target/lib
cp include/*.h ../../.target/include
cp libseq/mpi.h ../../.target/include
cp libseq/libmpiseq.a ../../.target/lib
cd ..
# Ipopt 3.11.7
if [ ! -d Ipopt-3.11.7 ]; then
    tar xzvf ../.download/Ipopt-3.11.7.tgz
    # bugfix for http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=625018#10
    cd Ipopt-3.11.7
    # create build directory
    mkdir -p build
    cd build
    # start building
    ../configure --enable-static --prefix $PSOPT_BUILD_DIR/.target -with-blas="-L$PSOPT_BUILD_DIR/.target/lib -lopenblas" --with-mumps-lib="-L$PSOPT_BUILD_DIR/.target/lib -ldmumps -lmumps_common -lpord -lmpiseq" --with-mumps-incdir="$PSOPT_BUILD_DIR/.target/include"
    make
    cd ../..
fi
# install
cd Ipopt-3.11.7/build
make install
cd ../..
# ColPack
if [ ! -d ColPack-1.0.9 ]; then
    tar xzvf ../.download/ColPack-1.0.9.tar.gz
    cd ColPack-1.0.9
    ./configure --enable-static --prefix $PSOPT_BUILD_DIR/.target --libdir=$PSOPT_BUILD_DIR/.target/lib64
    make
    # create shared library (necessary for linking with ADOL-C)
    # http://stackoverflow.com/questions/12163406/mingw32-compliation-issue-when-static-linking-is-required-adol-c-links-colpack
    g++ -shared -o libColPack.dll  CoutLock.o command_line_parameter_processor.o File.o DisjointSets.o current_time.o mmio.o Pause.o MatrixDeallocation.o Timer.o StringTokenizer.o extra.o stat.o BipartiteGraphPartialOrdering.o BipartiteGraphPartialColoring.o BipartiteGraphPartialColoringInterface.o BipartiteGraphInputOutput.o BipartiteGraphBicoloring.o BipartiteGraphVertexCover.o BipartiteGraphCore.o BipartiteGraphBicoloringInterface.o BipartiteGraphOrdering.o GraphCore.o GraphColoringInterface.o GraphInputOutput.o GraphOrdering.o GraphColoring.o JacobianRecovery1D.o RecoveryCore.o JacobianRecovery2D.o HessianRecovery.o
    cd ..
fi
cd ColPack-1.0.9
make install
cp libColPack.dll $PSOPT_BUILD_DIR/.target/lib64
sed -i -e "s#^library_names=''#library_names='libColPack.dll'#" $PSOPT_BUILD_DIR/.target/lib64/libColPack.la
chmod a+w $PSOPT_BUILD_DIR/.target/lib64/libColPack.la
cd ..
# Adol-C
if [ ! -d ADOL-C-2.4.1 ]; then
    tar xzvf ../.download/ADOL-C-2.4.1.tgz
    cd ADOL-C-2.4.1
    ./configure --enable-sparse --enable-static --with-colpack=$PSOPT_BUILD_DIR/.target --prefix $PSOPT_BUILD_DIR/.target
    make
    cd ..
fi
# installation
cd ADOL-C-2.4.1
make install
cd ..
# dlfcn
if [ ! -d dlfcn-19-6 ]; then
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
    cd ..
fi
cd dlfcn-19-6
export arch=WIN
./pkgbuild.sh
unset arch
cd ..
# libf2c
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
cd ..
# UFconfig
if [ ! -d UFconfig ]; then
    tar xzvf ../.download/UFconfig-3.6.1.tar.gz
    cd UFconfig
    sed -i -n 'H;${x;s/CC = cc/CC = gcc/;p;}' UFconfig.mk
    sed -i -n 'H;${x;s#/usr/local#'"$PSOPT_BUILD_DIR"'/.target#g;p;}' UFconfig.mk
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
# lusol
unzip ../.download/lusol.zip
cd lusol/csrc
tar xOzvf ../../../.download/Psopt3.tgz ./Psopt3/Makefile.lusol > Makefile
sed -i -n 'H;${x;s#I = -I.#& -I'"$PSOPT_BUILD_DIR"'/.target/include#;p;}' Makefile
make
cp liblusol.a $PSOPT_BUILD_DIR/.target/lib
cp *.h $PSOPT_BUILD_DIR/.target/include
cd ../..
# Unpack PSOPT (needed for DMatrix)
tar xzvf ../.download/Psopt3.tgz
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
patch -p1 < $PSOPT_BUILD_DIR/patches/psopt-gnuplot-windows.patch
patch -p1 < $PSOPT_BUILD_DIR/patches/psopt-c++0x-windows.patch
patch -p1 < $PSOPT_BUILD_DIR/patches/psopt-lambdafunction-windows.patch
patch -p1 < $PSOPT_BUILD_DIR/patches/psopt-bugfix-static-variable.patch
patch -p1 < $PSOPT_BUILD_DIR/patches/psopt-ipopt-3-11-7-compatibility.patch
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
cd PSOPT/lib
chmod a+w Makefile
echo -e "
MERGE_LIBS= -L$PSOPT_BUILD_DIR/.target/lib -L$PSOPT_BUILD_DIR/.target/lib/coin -L$PSOPT_BUILD_DIR/.target/lib/coin/ThirdParty -L$PSOPT_BUILD_DIR/.target/lib64 $< -ldmatrix -lcxsparse -ladolc -llusol -lipopt -ldmumps -lmumps_common -lesmumps -lscotch -lscotcherr -lpord -lmpiseq -lopenblas -lgfortran -ldl

libcombinedpsopt.so: \$(PSOPTSRCDIR)/psopt.o
\t\$(CXX) -shared \$(CXXFLAGS) \$(MERGE_LIBS) -o \$@
" >> Makefile
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
ADDLIB ../lib64/libColPack.a
ADDLIB liblusol.a
ADDLIB libipopt.a
ADDLIB libdmumps.a
ADDLIB libmumps_common.a
ADDLIB libpord.a
ADDLIB libmpiseq.a
ADDLIB libopenblas.a
ADDLIB libesmumps.a
ADDLIB libscotch.a
ADDLIB libscotcherr.a
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
if [ ! -f ../../NO_PSOPT_EXAMPLES ]; then
    make all
fi
cd ..
# Create Example
cd ..
mkdir -p obstacle
cp .packages/Psopt3/PSOPT/examples/obstacle/obstacle.cxx obstacle
echo "# name of the executable
TARGET = obstacle
# Put the object files of depencencies here and define make-procedures
# in this file
OBJECT_DEPS =
# Put extra compilerflags here
CXXFLAGSEXTRA =
# Put extra libraries here
EXTRALIBS =
# include default PSOPT make-rules for the project
include ../Makefile_include.mk

# this is called from clean
projectclean:

# this is called from psoptclean
projectpsoptclean:
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
\t$(CXX) $(CXXFLAGS) $(CXXFLAGSEXTRA) $(LINKFLAGS) $^ -o $@ $(EXTRALIBS) $(LIBRARIES)

$(TARGET).o: $(TARGET).cxx
\t$(CXX) -c $(CXXFLAGS) $(CXXFLAGSEXTRA) $(INCLUDES) $< -o $@

clean: projectclean
\trm -f *.o $(TARGET) $(TARGET).exe

psoptclean: clean projectpsoptclean
\trm -f $(TARGET).txt *.dat mesh_statistics* *.out psopt_solution_*.txt gnuplot.scp error_message.txt ADOLC-*.tap
' > Makefile_include.mk
cd obstacle
make
cd ..
# Modern Psopt Interface
cd .packages
unzip ../.download/modern-psopt-interface.zip
cd modern-psopt-interface-master
make PSOPT=../..
make install PSOPT=../.. PREFIX=../../.target
cd ../..
# Modern Obstacle Example
echo ""
echo "installation finished"
