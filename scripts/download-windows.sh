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


psoptInstallerDownload Psopt3.tgz http://psopt.googlecode.com/files/Psopt3.tgz
psoptInstallerDownload patch_3.02.zip http://psopt.googlecode.com/files/patch_3.02.zip
psoptInstallerDownload modern-psopt-interface.zip https://github.com/Sauermann/modern-psopt-interface/archive/master.zip
