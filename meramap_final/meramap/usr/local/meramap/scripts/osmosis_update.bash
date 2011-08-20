#!/bin/bash
#This scripts updates the area and insert the changes into the database

#Parameter: Intervall

PID_FILE="/var/run/osmios.pid"
SLEEP=/bin/sleep
SLEEP_TIME=180m

#Update-Intervall is parameter 1
if [ "$1" != "" ]; then
	SLEEP_TIME=$1;
fi

#Load variables
. /usr/local/meramap/scripts/variable.sh
if [ -e $PID_FILE ]; then
	echo "Is already running";
	exit 1
fi
if [ ! -e $OSMOSIS_AREA_FILE ]; then
	echo "Please install area.txt";
	exit 2;
fi

echo $$ > $PID_FILE


OSM2PG_PARAMS=$(cat $OSMOSIS_AREA_FILE)
while [ 0 ]; do
	/usr/bin/sudo -u $OSM_USER $OSMOSIS $OSMIOS_PARAMS --read-replication-interval workingDirectory=$WORKDIR_OSM --simplify-change --write-xml-change $WORKDIR_OSM/$OSMIOS_CHANGES &>> $MERAMAP/$LOGFILE_OSMOSIS
	/usr/bin/sudo -u postgres osm2pgsql --append -S $FILE_DEFAULT_STYLE --slim --bbox $OSM2PG_PARAMS -d $DBNAME -C 8192 $WORKDIR_OSM/$OSMIOS_CHANGES &>> $MERAMAP/$LOGFILE_OSM2PGSQL 
	$SLEEP $SLEEP_TIME
done
