#!/bin/sh
echo "setup_db.sh - Setting Up postgresql database......"
SCRIPTDIR="$( cd -P "$( dirname "$0" )" && pwd )"
source $SCRIPTDIR/variables.sh

cd $MERAMAP_API

sudo -u postgres createuser $DBUSER -s
sudo -u postgres createdb -E UTF8 -O $DBUSER openstreetmap 
sudo -u postgres createdb -E UTF8 -O $DBUSER osm_test
sudo -u postgres createdb -E UTF8 -O $DBUSER osm
sudo -u postgres psql -d openstreetmap < /usr/share/postgresql/8.4/contrib/btree_gist.sql

#sed -i -e 's/^abb/ABB/g' /usr/share/dict/words

echo "setup_db.sh complete!!"