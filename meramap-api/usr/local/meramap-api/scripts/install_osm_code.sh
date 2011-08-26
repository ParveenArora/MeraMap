#!/bin/sh
echo "install_osm_code.sh - Installing OSM Code......"
SCRIPTDIR="$( cd -P "$( dirname "$0" )" && pwd )"
source $SCRIPTDIR/variables.sh

cd $MERAMAP_API
#git clone git://git.openstreetmap.org/rails.git

DBCONF=$MERAMAP_API/rails/config/database.yml

cp $MERAMAP_API/rails/config/postgres.example.database.yml $DBCONF

sed -i -e 's/^username^/username: $DBUSER/g' $DBCONF
    

echo "install_osm_code.sh complete!!"