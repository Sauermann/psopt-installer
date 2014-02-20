#!/bin/bash

# scripts/install-colpack-windows.sh
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
cd ../..
