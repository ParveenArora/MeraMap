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
echo "install_osm_code.sh - Installing OSM Code......"
SCRIPTDIR="$( cd -P "$( dirname "$0" )" && pwd )"
echo "scriptdir = $SCRIPTDIR"
. $SCRIPTDIR/variables.sh

################################################################
# Download rails port code
###############################################################
if [ -e $MERAMAP_API/rails ]; then
    echo "updating rails port source code"
    cd $MERAMAP_API/rails
    git pull
else
    echo "downloading rails port source code from git.openstreetmap.org"
    cd $MERAMAP_API
    git clone git://git.openstreetmap.org/rails.git
    mkdir 0666 $MERAMAP_API/rails/log
    chmod 0666 $MERAMAP_API/rails/log/*
fi




###################################################################
# Install osmosis
###################################################################
cd $MERAMAP_API
if [ -e /usr/local/bin/osmosis ]; then
   echo "You already have a local version of osmosis in /usr/local/bin - using that"
else
    wget http://dev.openstreetmap.org/~bretth/osmosis-build/osmosis-latest.tgz -O osmosis-latest.tgz
    tar -xvf osmosis-latest.tgz
    ln -s $MERAMAP_API/osmosis*/bin/osmosis /usr/local/bin/osmosis
fi

echo "install_osm_code.sh complete!!"

