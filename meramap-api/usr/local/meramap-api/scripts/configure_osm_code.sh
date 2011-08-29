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
#
# This script configures the OSM rails port, which should have been installed
# by install_osm_code.
# If it is called with a command line parameter 'reset', it will do a complete
# reconfiguration.  Otherwise if application.yml exists in rails/config
#  it will not overwrite it in case the user has customised it.
#
##############################################################################

echo "******************************************************************"
echo "configure_osm_code.sh - Installing OSM Code......"
SCRIPTDIR="$( cd -P "$( dirname "$0" )" && pwd )"
echo "scriptdir = $SCRIPTDIR"
. $SCRIPTDIR/variables.sh

################################################################
# Configure rails port
################################################################
DBTEMP=$MERAMAP_API/rails/config/postgres.example.database.yml
DBCONF=$MERAMAP_API/rails/config/database.yml
APPTEMP=$MERAMAP_API/rails/config/example.application.yml
APPCONF=$MERAMAP_API/rails/config/application.yml

######################################
# Reset if requested necessary
######################################
if [ $1 = "reset" ]; then
    echo "Resetting completely."
    rm $DBCONF $APPCONF
fi



if [ -e $DBCONF ]; then 
    echo "****$DBCONF already exists, not changing it! ****"
else
    echo "Configuring database settings in $DBCONF"
    #This first strips any leading white space or # character before username.
    #then replaces username with the desired value.
#    sed -e 's/^[#]*//' -e "s/username./username: $DBUSER #/g" -e "s/password./password: $DBPASS #/g" $DBTEMP > $DBCONF
#    sed -e 's/^[ \t#]*//' -e "s/username./  username:$DBUSER #/g" -e "s/password./  password:$DBPASS #/g" $DBTEMP > $DBCONF
    sed -e "s/.*username.*/  username: $DBUSER/g" -e "s/.*password.*/  password: $DBPASS/g" $DBTEMP > $DBCONF
fi

if [ -e $APPCONF ]; then
    echo "**** $APPCONF already exists, not changing it! ****"
else
    echo "Configuring API URLs etc. in $APPCONF"
    cp $APPTEMP $APPCONF
    # replaces 'openstreetmap' with 'meramap-api' in the URLs etc.
#    sed -i'.bak' -e "s/openstreetmap/meramap-api #/g" $APPCONF
    # set the GPX traces and images directories.
    mkdir -p $PATH_GPX_TRACES
    sed -i'.bak' -e "s|.*gpx_trace_dir.*|  gpx_trace_dir: $PATH_GPX_TRACES|g" $APPCONF
    mkdir -p $PATH_GPX_IMAGES
    sed -i'.bak' -e "s|.*gpx_image_dir.*|  gpx_image_dir: $PATH_GPX_IMAGES|g" $APPCONF

    # Replace every occurence of 'openstreetmap.org' with $API_DOMAIN
    cd $RAILSDIR
    FILE_LIST=$MERAMAP_API/rails/file_list.txt
    if [ -e $FILE_LIST ]; then
	rm $FILE_LIST
    fi
    rgrep -R -l openstreetmap.org * > $FILE_LIST
    xargs sed -i'.bak' -e "s/openstreetmap.org/$API_DOMAIN/g" < $FILE_LIST
    rm $FILE_LIST

fi

echo "installing gems libraries...."
cd $MERAMAP_API/rails
rake gems:install

echo "Setting up the databases...."
cd $MERAMAP_API/rails
echo "development database..."
rake db:migrate
echo "production database..."
env RAILS_ENV=production rake db:migrate

#echo "Running tests..."
#rake test




echo ""
echo "configure_osm_code.sh complete!"
echo ""
echo ""