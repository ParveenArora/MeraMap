#!/bin/bash
source $MERAMAP_SCRIPT/variables.sh

source $MERAMAP/bin/mapnik/archive/set-mapnik-env
.$MERAMAP/bin/mapnik/archive/customize-mapnik-map > $MAPNIK_MAP_FILE
.$MERAMAP/bin/mapnik/z0_generate_tiles.py
