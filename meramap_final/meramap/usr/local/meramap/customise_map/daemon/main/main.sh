#!/bin/bash
source /usr/local/meramap/customise_map/daemon/main/scripts/variable.sh

if [ -d logfiles ]; then sudo rm -r logfiles; fi
mkdir logfiles
echo "Wait, Your Selected Data file is Downloading..."
if [ -f $OUTPUT ]; then rm -r $OUTPUT; fi
sudo python $FILE_REPLACE_AND_DOWNLOAD  >> $LOGFILE_INST 2>&1 
echo "Data is importing to postgresql..."

sudo ./$FILE_POSTGRE_DB  >> $LOGFILE_INST 2>&1 

if [ -f $FILE_DEFAULT_STYLE ];
then
    echo ""
    sudo -u postgres osm2pgsql -S $FILE_DEFAULT_STYLE --slim -d $DBNAME -C 2048 $FILE_OSMDATAFILE >> $LOGFILE_OSM2PGSQL 2>&1
 echo "Data Successfully Imported to Database"
fi
echo ""
echo "* * * * * * * * * * * * * * * * * * * * * *"
echo "Wait while your tiles are being generated"
echo "* * * * * * * * * * * * * * * * * * * * * *"

./$SCRIPT_GENERATE_TILES >> $LOGFILE_INST 2>&1      #Script to generate map tiles.
echo "Tiles has been Generated"
echo "Now Generating Map"
./$SCRIPT_GEN_MAP                                   #script to show map on web browser. 
echo "Complete"

