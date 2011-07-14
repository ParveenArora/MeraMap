#!/bin/bash
source variable.sh

if [ -e $LOGFILE_TILES ]; then rm $LOGFILE_TILES; fi

echo $0 >> $LOGFILE_TILES 2>&1


source $SET_MAPNIK_ENV
cd $MAPNIK_ARCHIVE
pwd >> $LOGFILE_TILES 2>&1
./customize-mapnik-map >$MAPNIK_MAP_FILE
cd ..
pwd >> $LOGFILE_TILES 2>&1
./z0_generate_tiles.py >> $LOGFILE_TILES 2>&1
