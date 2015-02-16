#!/bin/bash

psoptInstallerDownload()
{
    mkdir -p .download
    if [ ! -f .download/$1 ]; then
        wget -O .download/$1 --no-check-certificate $2
    fi;
}

# Handle existence of Variable
if [ -z "${PSOPT_BUILD_DIR+x}" ]; then
    export PSOPT_BUILD_DIR="$(pwd)"
    export RESET_PSOPT_BUILD_DIR="1"
fi

mkdir -p .packages
mkdir -p $PSOPT_BUILD_DIR/.target/lib
mkdir -p $PSOPT_BUILD_DIR/.target/include
