#!/bin/sh
echo "populate_sample_db.sh - Installing Sample OSM data into database......"
SCRIPTDIR="$( cd -P "$( dirname "$0" )" && pwd )"
echo "scriptdir = $SCRIPTDIR"
. $SCRIPTDIR/variables.sh

cd $MERAMAP_API

OSMFILE=sampledata.osm
if [ -e $OSMFILE ]; then
    echo "OSM Data File $OSMFILE already exists, using that..."
else
    echo "Downloading sample OSM data to use in database..."
    wget --timeout=600 http://jxapi.openstreetmap.org/xapi/api/0.6/map?bbox=$MINLON,$MINLAT,$MAXLON,$MAXLAT -O $OSMFILE
fi

echo "Reseting database counters...."
psql -d openstreetmap -U $DBUSER -f $SCRIPTDIR/reset_autoincrement_tables.sql

echo "Importing data into database..."
osmosis --read-xml-0.6 file="$OSMFILE" --write-apidb-0.6 populateCurrentTables=yes host="localhost" database="openstreetmap" user="$DBUSER" password="$DBPASS" validateSchemaVersion=no


echo "populate_sample_db.sh complete!!"