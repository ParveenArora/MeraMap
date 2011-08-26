#!/bin/sh
echo "install_osm_code.sh - Installing OSM Code......"
SCRIPTDIR="$( cd -P "$( dirname "$0" )" && pwd )"
source $SCRIPTDIR/variables.sh

cd $MERAMAP_API
#git clone git://git.openstreetmap.org/rails.git

DBTEMP=$MERAMAP_API/rails/config/postgres.example.database.yml
DBCONF=$MERAMAP_API/rails/config/database.yml

#This first strips any leading white space or # character before username.
#then replaces username with the desired value.
sed -e 's/^[ \t#]*username//' -e 's/username./  username: $DBUSER #/g' $DBTEMP > $DBCONF

#sed -e 's/.username./username: $DBUSER/g' $DBTEMP > $DBCONF
    
#sed -e 's/^[ \t#]*//' -e 's/.username./NEWTEXT/g' postgres.example.database.yml


echo "install_osm_code.sh complete!!"