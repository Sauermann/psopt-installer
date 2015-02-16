#!/bin/bash

# scripts/download-windows.sh
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

psoptInstallerDownload()
{
    mkdir -p .download
    if [ ! -f .download/$1 ]; then
        wget -O .download/$1 --no-check-certificate $2
    fi;
}


psoptInstallerDownload ADOL-C-2.4.1.tgz http://www.coin-or.org/download/source/ADOL-C/ADOL-C-2.4.1.tgz
psoptInstallerDownload dlfcn-win32-r19-6-mingw_i686-src.tar.xz http://lrn.no-ip.info/packages/i686-w64-mingw/dlfcn-win32/r19-6/dlfcn-win32-r19-6-mingw_i686-src.tar.xz
psoptInstallerDownload libf2c.zip http://www.netlib.org/f2c/libf2c.zip
psoptInstallerDownload Psopt3.tgz http://psopt.googlecode.com/files/Psopt3.tgz
psoptInstallerDownload patch_3.02.zip http://psopt.googlecode.com/files/patch_3.02.zip
psoptInstallerDownload UFconfig-3.6.1.tar.gz http://www.cise.ufl.edu/research/sparse/SuiteSparse_config/UFconfig-3.6.1.tar.gz
psoptInstallerDownload CXSparse-2.2.5.tar.gz http://www.cise.ufl.edu/research/sparse/CXSparse/versions/CXSparse-2.2.5.tar.gz
psoptInstallerDownload lusol.zip http://www.stanford.edu/group/SOL/software/lusol/lusol.zip
psoptInstallerDownload modern-psopt-interface.zip https://github.com/Sauermann/modern-psopt-interface/archive/master.zip
