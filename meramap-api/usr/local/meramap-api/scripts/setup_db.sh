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

echo "setup_db.sh - Setting Up postgresql database......"
SCRIPTDIR="$( cd -P "$( dirname "$0" )" && pwd )"
. $SCRIPTDIR/variables.sh

cd $MERAMAP_API

echo "Deleting existing databases if they are present..."
echo "drop database if exists openstreetmap;" | sudo -u postgres psql -d template1 
echo "drop database if exists osm_test;" | sudo -u postgres psql -d template1 
echo "drop database if exists osm;" | sudo -u postgres psql -d template1 
echo "drop user if exists $DBUSER;" | sudo -u postgres psql -d template1 

echo "Creating new databases and user....."
sudo -u postgres createuser $DBUSER -s
sudo -u postgres createdb -E UTF8 -O $DBUSER openstreetmap 
sudo -u postgres createdb -E UTF8 -O $DBUSER osm_test
sudo -u postgres createdb -E UTF8 -O $DBUSER osm
sudo -u postgres psql -d openstreetmap < /usr/share/postgresql/8.4/contrib/btree_gist.sql

echo "ALTER user $DBUSER with password '$DBPASS';"
echo "ALTER user $DBUSER with password '$DBPASS';" | sudo -u postgres psql -d openstreetmap 

echo "setup_db.sh complete!!"