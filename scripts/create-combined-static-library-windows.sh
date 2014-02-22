#!/bin/bash

# scripts/create-combined-static-library-windows.sh
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

# PSOPT combined static library
cd .target/lib
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
cd ../..
