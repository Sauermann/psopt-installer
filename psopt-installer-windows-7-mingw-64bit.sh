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

# hide most windows paths
export ORIGINAL_PATH=$PATH
export PATH=".:/mingw/bin:/bin:/c/Windows/System32"
# Build Directory
export PSOPT_BUILD_DIR=$PWD
# Download packages
./scripts/download-windows.sh
# Predependency Packages
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
cd .packages
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
