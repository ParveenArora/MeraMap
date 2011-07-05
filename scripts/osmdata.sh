#!/bin/bash
if [ -d ~/plane ];
then
    echo "File exists"
else
    mkdir ~/plane

fi

if [ -f ~/planet/ludhiana.osm.bz2 ];
then
    echo "OSM Data File for Ludhiana exists"
else 
    cd ~/plane
    wget https://github.com/ParveenArora/MeraMap/blob/master/osm_data_file/ludhiana.osm.bz2
fi
