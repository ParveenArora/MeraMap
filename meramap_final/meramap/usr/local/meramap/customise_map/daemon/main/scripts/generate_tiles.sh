#!/bin/bash
source scripts/variable.sh

if [ -e $LOGFILE_TILES ]; then rm $LOGFILE_TILES; fi

echo $0 >> $LOGFILE_TILES 2>&1

source $SET_MAPNIK_ENV
cd $MAPNIK_ARCHIVE
pwd >> $LOGFILE_TILES 2>&1
./customize-mapnik-map >$MAPNIK_MAP_FILE
cd /usr/local/meramap/customise_map/daemon/main/scripts/
pwd >> $LOGFILE_TILES 2>&1
python output.py
