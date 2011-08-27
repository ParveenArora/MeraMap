#!/bin/sh
echo "install_osm_code.sh - Installing OSM Code......"
SCRIPTDIR="$( cd -P "$( dirname "$0" )" && pwd )"
echo "scriptdir = $SCRIPTDIR"
. $SCRIPTDIR/variables.sh

if [ -e $MERAMAP_API/rails ]; then
    echo "updating rails port source code"
    cd $MERAMAP_API/rails
    git pull
else
    echo "downloading rails port source code from git.openstreetmap.org"
    cd $MERAMAP_API
    git clone git://git.openstreetmap.org/rails.git
fi

DBTEMP=$MERAMAP_API/rails/config/postgres.example.database.yml
DBCONF=$MERAMAP_API/rails/config/database.yml
APPTEMP=$MERAMAP_API/rails/config/example.application.yml
APPCONF=$MERAMAP_API/rails/config/application.yml

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
    # replaces 'openstreetmap' with 'meramap-api' in the URLs etc.
    sed -e "s/openstreetmap/meramap-api #/g" $APPTEMP > $APPCONF
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

echo "Running tests..."
rake test
echo "install_osm_code.sh complete!!"