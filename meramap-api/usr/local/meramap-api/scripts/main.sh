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


echo "#######################################################"
echo "# MeraMap-Api - OpenStreetMap API Server Installation #"
echo "#######################################################"
echo ""

SCRIPTDIR="$( cd -P "$( dirname "$0" )" && pwd )"
echo "scriptdir = $SCRIPTDIR"
. $SCRIPTDIR/variables.sh

echo "You can track progress during installation by monitoring $LOGFILE_INST"
echo ""

if [ -e $LOGFILE_INST ]; then rm $LOGFILE_INST; fi 

echo "Initialising Database..."
/bin/sh $SCRIPTDIR/setup_db.sh >> $LOGFILE_INST 2>&1
echo "Installing ruby gems libraries...."
/bin/sh $SCRIPTDIR/install_ruby_gems.sh >> $LOGFILE_INST 2>&1
echo "Installing OSM rails port and other OSM code...."
/bin/sh $SCRIPTDIR/install_osm_code.sh >> $LOGFILE_INST 2>&1
echo "Populating database with sample data...."
/bin/sh $SCRIPTDIR/populate_sample_db.sh >> $LOGFILE_INST 2>&1

echo "Starting Development Server...."
/bin/sh $SCRIPTDIR/run_server.sh >> $LOGFILE_INST 2>&1

echo "Setup Complete - you should see a copy of the OpenStreetMap.org website at http://localhost:3000"
echo ""
echo "If you are having problems, have a look at the log file at $LOGFILE_INST."
echo ""



