#!/bin/bash
source $MERAMAP_SCRIPT/variables.sh
if [ -d $MERAMAP/$PLANET ];
then
    echo "File exists"
else
    mkdir $MERAMAP/$PLANET

fi

if [ -f $MERAMAP/$OSMDATAFILE ];
then
    echo "OSM Data File for Ludhiana exists"
else 
     cp $MERAMAP/$FILE_OSMDATA $PLANET
fi
