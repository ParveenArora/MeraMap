#!/bin/bash
source variables.sh
if [ -d $BIN ];
then
    echo "Directory exists"
else
    mkdir $BIN

fi
cp -r mapnik $BIN
