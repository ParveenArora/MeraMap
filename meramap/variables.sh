#This file contains all the variables using in all the files

#Variables which are defineing log files.
LOGFILE=postgres_meramap.log
LOGFILE_OSM2PGSQL=osm2pgsql.log
LOGFILE_INST=meramap.log

#Variables Defining Database Username and Database Name
DBNAME=meramap_dba
DBUSER=meramap_user

#This is the command to know the verison of ubuntu being used by the user.
UBUNTUVERSION=`lsb_release -r | cut -f2`

#This variables are defining path to directories.
PLANET=planet
BIN=bin
PUBLIC_HTML=~/public_html

#These variables are to files with there path
FILE_OSMDATAFILE=planet/ludhiana.osm.bz2
FILE_POSTGRE_PATH=/etc/postgresql/8.4/main/postgresql.conf
FILE_POSTGRE_CONFIG=postgresql_config.conf
FILE_DEFAULT_STYLE=/usr/share/osm2pgsql/osm2pgsql/default.style

#These variables defines the scripts that are being used.
FILE_SCRIPT_OSMDATA=osmdata.sh
FILE_POSTGRE_DB=postgre_db_config.sh
FILE_PATCH=postgresql.patch
FILE_POSTGRE_PATCH=postgre_patch.sh
FILE_DEFAULT_FILE_STYLE=default.style
SCRIPT_OSM2PGSQL=osm2pgsql.sh
SCRIPT_MAPNIK_TOOLS=mapnik_tools.sh
SCRIPT_MAPNIK_TILES=mapnik_tiles.sh
SCRIPT_RUNMAP=run_map.sh
