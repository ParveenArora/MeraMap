#!/bin/bash
source $MERAMAP_SCRIPT/variables.sh
if [ -d $MERAMAP/$BIN ];
then
    echo "Directory exists"
else
    mkdir $MERAMAP/$BIN

fi
cp -r mapnik $MERAMAP/$BIN
