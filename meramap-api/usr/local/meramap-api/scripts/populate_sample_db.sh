#!/bin/sh
############################################################################
#    Copyright 2011 Graham Jones
#
#    This file is part of Meramap-api.
#
#    Meramap-api is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    Meramap-api is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with Meramap-api.  If not, see <http://www.gnu.org/licenses/>.
############################################################################

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