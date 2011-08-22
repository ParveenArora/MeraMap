#!/bin/bash
python downloadOsmData.py

if [ -f default.style ];
then
    echo "File Exit"
    sudo -u postgres osm2pgsql -S default.style --slim -d meramap_dba -C 2048 tmp.osm 
    echo "Its OK"
fi

#python test.py
