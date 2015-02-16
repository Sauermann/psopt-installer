#!/bin/bash

psoptInstallerDownload()
{
    mkdir -p .download
    if [ ! -f .download/$1 ]; then
        wget -O .download/$1 --no-check-certificate $2
    fi;
}
