#!/bin/bash

psoptInstallerDownload()
{
    if [ ! -f $1 ]; then
        wget -O $1 --no-check-certificate $2
    fi;
}
