#!/bin/sh
SCRIPTDIR="$( cd -P "$( dirname "$0" )" && pwd )"
echo "scriptdir = $SCRIPTDIR"
. $SCRIPTDIR/variables.sh

if [ -e $LOGFILE_SRV ]; then rm $LOGFILE_SRV; fi 

echo "Starting ruby/rails test Server...."
cd $MERAMAP_API/rails
ruby script/server >> $LOGFILE_SRV 2>&1 &
echo "Done - you should be able to see the site at http://localhost:3000"




