#!/bin/bash

# scripts/install-mumps.sh
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

# Note to self: Whenever there is a new version of Mumps, test if the
# new version is compatible with Metis
# http://glaros.dtc.umn.edu/gkhome/metis/metis/overview
# in order to perhaps replace scotch
# http://code-saturne.org/forum/viewtopic.php?f=3&t=52
# http://www.cs.umn.edu/~agupta/doc/pp10.pdf

# Version
export PSOPT_MUMPS_VERSION="4.9.2"

# Download
source ./scripts/prescript.sh
psoptInstallerDownload MUMPS_${PSOPT_MUMPS_VERSION}.tar.gz http://mumps.enseeiht.fr/MUMPS_${PSOPT_MUMPS_VERSION}.tar.gz

# Compile
mkdir -p .packages
cd .packages
if [ ! -d MUMPS_${PSOPT_MUMPS_VERSION} ]; then
    tar xzvf ../.download/MUMPS_${PSOPT_MUMPS_VERSION}.tar.gz
    cd MUMPS_${PSOPT_MUMPS_VERSION}
    cp Make.inc/Makefile.gfortran.SEQ Makefile.inc
    sed -i 's|#SCOTCHDIR  = ${HOME}/scotch_5.1_esmumps|SCOTCHDIR  = $(PSOPT_BUILD_DIR)/.target/lib|' Makefile.inc
    sed -i 's|#LSCOTCH    = -L$(SCOTCHDIR)/lib -lesmumps -lscotch -lscotcherr|LSCOTCH    = -L$(SCOTCHDIR) -lesmumps -lscotch -lscotcherr|' Makefile.inc
    sed -i 's#ORDERINGSF  = -Dpord#& -Dscotch#' Makefile.inc
    sed -i 's#-lblas#-lopenblas#' Makefile.inc
    make
    cd ..
fi

# Install
mkdir -p $PSOPT_BUILD_DIR/.target/lib
mkdir -p $PSOPT_BUILD_DIR/.target/include
cd MUMPS_${PSOPT_MUMPS_VERSION}
cp lib/*.a ../../.target/lib
cp include/*.h ../../.target/include
cp libseq/mpi.h ../../.target/include
cp libseq/libmpiseq.a ../../.target/lib
cd ../..

# Reset
unset PSOPT_MUMPS_VERSION

source ./scripts/postscript.sh
