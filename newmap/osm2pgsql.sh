#!/bin/bash
source variable.sh

if [ -e $LOGFILE_OSM2PGSQL  ]; then rm $LOGFILE_OSM2PGSQL; fi
echo $0 >> $LOGFILE_OSM2PGSQL 2>&1

if [ -f $FILE_DEFAULT_STYLE ];
then
    echo "File exists" >> $LOGFILE_OSM2PGSQL 2>&1
    osm2pgsql -S $FILE_DEFAULT_STYLE --slim -d $DBNAME -C 2048 $FILE_OSMDATAFILE >> $LOGFILE_OSM2PGSQL 2>&1
else
    osm2pgsql -S $FILE_DEFAULT_FILE_STYLE --slim -d $DBNAME -C 2048 $FILE_OSMDATAFILE >> $LOGFILE_OSM2PGSQL 2>&1
fi

