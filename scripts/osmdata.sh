#!/bin/bash
if [ -d ~/planet ];
then
    echo "File exists"
else
    mkdir ~/planet

fi

if [ -f ~/planet/ludhiana.osm.bz2 ];
then
    echo "OSM Data File for Ludhiana exists"
else 
    cd ~/planet
    wget https://github.com/ParveenArora/MeraMap/blob/master/osm_data_file/ludhiana.osm.bz2
fi
