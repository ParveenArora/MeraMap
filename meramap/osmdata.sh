#!/bin/bash
source variables.sh
if [ -d $PLANET ];
then
    echo "File exists"
else
    mkdir $PLANET

fi

if [ -f $OSMDATAFILE ];
then
    echo "OSM Data File for Ludhiana exists"
else 
     cp $FILE_OSMDATA $PLANET
fi
