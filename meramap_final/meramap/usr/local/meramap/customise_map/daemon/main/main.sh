#!/bin/bash
source scripts/variable.sh
echo "Wait ............."
sudo python $FILE_REPLACE_AND_DOWNLOAD  >> $LOGFILE_INST 2>&1 

sudo ./$FILE_POSTGRE_DB  >> $LOGFILE_INST 2>&1 

if [ -f $FILE_DEFAULT_STYLE ];
then
    echo "File Exit"
    sudo -u postgres osm2pgsql -S $FILE_DEFAULT_STYLE --slim -d $DBNAME -C 2048 $FILE_OSMDATAFILE >> $LOGFILE_OSM2PGSQL 2>&1
 echo "Its OK"
fi

./$SCRIPT_GENERATE_TILES >> $LOGFILE_INST 2>&1      #Script to generate map tiles.

#./$SCRIPT_GEN_MAP                                   #script to show map on web browser. 
echo "complete"

