#!/bin/sh
SCRIPTDIR="$( cd -P "$( dirname "$0" )" && pwd )"
echo "scriptdir = $SCRIPTDIR"
. $SCRIPTDIR/variables.sh

echo "Starting ruby/rails test Server...."
cd $MERAMAP_API/rails
ruby script/server >> $LOGFILE_SRV 2>&1 &
echo "Done - you should be able to see the site at http://localhost:3000"




