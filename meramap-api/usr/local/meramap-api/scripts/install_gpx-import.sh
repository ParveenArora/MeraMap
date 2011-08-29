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
echo ""
echo "**********************************************************"
echo "install_gpx-import.sh - Installing gpx-import daemon......"
SCRIPTDIR="$( cd -P "$( dirname "$0" )" && pwd )"
echo "scriptdir = $SCRIPTDIR"
. $SCRIPTDIR/variables.sh


###################################################################
# Install gpx-import daemon
###################################################################
if [ -e $MERAMAP_API/gpx-import ]; then
    echo "updating gpx-import daemon source code"
    cd $MERAMAP_API/gpx-import
    git pull
else
    echo "downloading gpx-import daemon source code from github"
    cd $MERAMAP_API

    #*******NOTE - THIS IS G. JONES' VERSION, NOT THE OFFICIAL OSM ONE******
    git clone git://github.com/jones139/gpx-import.git
fi

cd $MERAMAP_API/gpx-import
make DB=postgres -C src

###################################################################
# Configure gpx-import daemon by creating meramap-settings.sh file
###################################################################
APPCONF=$MERAMAP_API/gpx-import/meramap-settings.sh
APPTEMP=$MERAMAP_API/gpx-import/settings.sh
if [ -e $APPCONF ]; then
    echo "**** $APPCONF already exists, not changing it! ****"
else
    cp $APPTEMP $APPCONF
    echo "Configuring gpx-import daemon in $APPCONF"
    mkdir -p $MERAMAP_API/gpx
    mkdir -p $PATH_GPX_TRACES
    mkdir -p $PATH_GPX_IMAGES

    sed -i'.bak' -e "s|.*setting PATH_TRACES.*|setting PATH_TRACES $PATH_GPX_TRACES|g" $APPCONF
    sed -i'.bak' -e "s|.*setting PATH_IMAGES.*|setting PATH_IMAGES $PATH_GPX_IMAGES|g" $APPCONF
    sed -i'.bak' -e "s|.*setting PATH_TEMPLATES.*|setting PATH_TEMPLATES $MERAMAP_API/gpx-import/templates|g" $APPCONF
    sed -i'.bak' -e "s|.*setting PGSQL_USER.*|setting PGSQL_USER $DBUSER|g" $APPCONF
    sed -i'.bak' -e "s|.*setting PGSQL_PASS.*|setting PGSQL_PASS $DBPASS|g" $APPCONF
    sed -i'.bak' -e "s|.*setting LOG_FILE.*|setting LOG_FILE $MERAMAP_API/gpx/gpx-import.log|g" $APPCONF
    sed -i'.bak' -e "s|.*setting PID_FILE.*|setting PID_FILE $MERAMAP_API/gpx/gpx-import.pid|g" $APPCONF
    sed -i'.bak' -e "s|\$\@|$MERAMAP_API/gpx-import/src/gpx-import|g" $APPCONF
fi

chmod a+x $APPCONF
if [ -e /etc/init.d/gpx-import ]; then
    echo "/etc/init.d already contains gpx-import - not changing it."
else
    ln -s $APPCONF /etc/init.d/gpx-import
    ln -s /etc/init.d/gpx-import /etc/rc3.d/S99gpx-import
fi

echo "Starting gpx-import daemon"
/etc/init.d/gpx-import start

echo "install_gpx-import.sh complete!"
echo ""


