#!/bin/bash
source $MERAMAP_SCRIPT/variables.sh

source $MERAMAP/bin/mapnik/archive/set-mapnik-env
./bin/mapnik/archive/customize-mapnik-map > $MAPNIK_MAP_FILE
./bin/mapnik/z0_generate_tiles.py
