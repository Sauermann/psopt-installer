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

cd .packages
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
cd ../..
