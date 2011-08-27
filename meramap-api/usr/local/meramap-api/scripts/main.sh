#!/bin/sh
SCRIPTDIR="$( cd -P "$( dirname "$0" )" && pwd )"
echo "scriptdir = $SCRIPTDIR"
. $SCRIPTDIR/variables.sh

if [ -e $LOGFILE_INST ]; then rm $LOGFILE_INST; fi #To check for log file If already exists or not. If it already exists then it will delete the previous log file. 

echo "Initialising Database..."
. $SCRIPTDIR/setup_db.sh >> $LOGFILE_INST 2>&1
echo "Installing ruby gems libraries...."
. $SCRIPTDIR/install_ruby_gems.sh >> $LOGFILE_INST 2>&1
echo "Installing OSM rails port and other OSM code...."
. $SCRIPTDIR/install_osm_code.sh >> $LOGFILE_INST 2>&1
echo "Populating database with sample data...."
. $SCRIPTDIR/populate_sample_db.sh >> $LOGFILE_INST 2>&1

echo "Starting Development Server...."
. $SCRIPTDIR/run_server.sh >> $LOGFILE_INST 2>&1

echo "Setup Complete - you should see a copy of the OpenStreetMap.org website at http://localhost:3000"
echo ""
echo "If you are having problems, have a look at the log file at $LOGFILE_INST."
echo ""



