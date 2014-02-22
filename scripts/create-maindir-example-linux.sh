#!/bin/bash

# scripts/create-maindir-example-linux.sh
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
LIBRARIES = -fPIC -L$(INSTALLDIR).target/lib -L$(INSTALLDIR).target/lib64 -lpsopt -ldmatrix -llusol -lcxsparse -lipopt -ldmumps -lmumps_common -lpord -lmpiseq -lopenblas -lesmumps -lscotch -lscotcherr -ladolc -lColPack -lgfortran -lpthread -lm -lgcc -ldl -static

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
