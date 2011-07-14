#!/bin/bash
source variables.sh

source /home/parveen/bin/mapnik/archive/set-mapnik-env
sh /home/parveen/bin/mapnik/archive/customize-mapnik-map > $MAPNIK_MAP_FILE
python /home/parveen/bin/mapnik/z0_generate_tiles.py
