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

SCRIPTDIR="$( cd -P "$( dirname "$0" )" && pwd )"
echo "scriptdir = $SCRIPTDIR"
. $SCRIPTDIR/variables.sh

if [ -e $LOGFILE_SRV ]; then rm $LOGFILE_SRV; fi 

echo "Starting ruby/rails test Server...."
cd $MERAMAP_API/rails
ruby script/server >> $LOGFILE_SRV 2>&1 &
echo "Done - you should be able to see the site at http://localhost:3000"




