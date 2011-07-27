#!/bin/bash
# NAME: postgr_db_gj.sh
# DESC: Creates a postgresql database and installs the postgis extension
#       to make it ready to accept openstreetmap data for rendering
#       using mapnik.
#       This script is part of MeraMap.
# HIST: 06 July 2011   Original Version by Parveen Arora
#       06 July 2011   Modified to work on multiple Ubuntu versions
#                       by Graham Jones.

source scripts/variable.sh
pwd
if [ -e $LOGFILE ]; then rm $LOGFILE; fi

echo $0 >> $LOGFILE 2>&1
if [ -e $LOGFILE ]; then echo logfile created; fi
echo $DBNAME
echo $DBUSER
echo $UBUNTUVERSION

if [ $UBUNTUVERSION = "10.04" ]; then
   echo "Ubuntu Version 10.04 Detected"
    POSTGIS_SQL="/usr/share/postgresql/8.4/contrib/postgis.sql"
    SPATIAL_SQL="/usr/share/postgresql/8.4/contrib/spatial_ref_sys.sql"
    INT_SQL="/usr/share/postgresql/8.4/contrib/_int.sql"

elif [ $UBUNTUVERSION = "10.10" ]; then
    echo "Ubuntu Version 10.10 Detected"
    POSTGIS_SQL="/usr/share/postgresql/8.4/contrib/postgis-1.5/postgis.sql"
    SPATIAL_SQL="/usr/share/postgresql/8.4/contrib/postgis-1.5/spatial_ref_sys.sql"
    INT_SQL="/usr/share/postgresql/8.4/contrib/_int.sql"


elif [ $UBUNTUVERSION = "11.04" ]; then
    echo "Ubuntu Version 11.04 Detected"
    POSTGIS_SQL="/usr/share/postgresql/8.4/contrib/postgis-1.5/postgis.sql"
    SPATIAL_SQL="/usr/share/postgresql/8.4/contrib/postgis-1.5/spatial_ref_sys.sql"
    INT_SQL="/usr/share/postgresql/8.4/contrib/_int.sql"

else
    echo "ERROR - Ubuntu Version $UBUNTUVERSION is not supported"
    exit
fi

echo "Setting up database and user..."


sudo -u postgres dropdb $DBNAME >> $LOGFILE 2>&1
sudo -u postgres dropuser $DBUSER >> $LOGFILE 2>&1
sudo -u postgres createdb $DBNAME >> $LOGFILE 2>&1
sudo -u postgres createuser --no-createdb --no-superuser --no-createrole $DBUSER >> $LOGFILE 2>&1
sudo -u postgres createlang plpgsql $DBNAME; >> $LOGFILE 2>&1
sudo -u postgres psql -f $POSTGIS_SQL -d $DBNAME >> $LOGFILE 2>&1
sudo -u postgres psql -f $SPATIAL_SQL -d $DBNAME >> $LOGFILE  2>&1
sudo -u postgres psql -f $INT_SQL -d $DBNAME >> $LOGFILE 2>&1

sudo -u postgres echo "ALTER TABLE geometry_columns OWNER TO $DBUSER; ALTER TABLE spatial_ref_sys OWNER TO $DBUSER;" | sudo -u postgres psql -d $DBNAME >> $LOGFILE 2>&1
sudo -u postgres psql -f sql/900913.sql -d $DBNAME >> $LOGFILE 2>&1

echo "Done!"

