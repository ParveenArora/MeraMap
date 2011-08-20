#!/bin/bash#!/bin/bash
#This file contains all the variables using in all the files
#Variables which are defineing log files. These all log files will be in the /usr/local/meramap
LOGFILE=logfiles/postgres_meramap.log       #Log file to which includes all the 
LOGFILE_OSM2PGSQL=logfiles/osm2pgsql.log    #Log file to load osm data into pgsql 
LOGFILE_INST=logfiles/meramap.log           #Whole Installation Log File
LOGFILE_TILES=logfiles/tiles.log    

#Variables Defining Database Username and Database Name
DBNAME=meramap_customise_dba                 #PostgreSQL Database Name
DBUSER=meramap_customise_user                #PosrgreSQL Database Username 

#This is the command to know the verison of ubuntu being used by the user.
UBUNTUVERSION=`lsb_release -r | cut -f2`     

#These variables are to files with there path
FILE_OSMDATAFILE=tmp.osm                        #Ludhiana's OSM Data file, only to run the system
FILE_POSTGRE_PATH=/etc/postgresql/8.4/main/postgresql.conf      #PostgreSQL Configuration File
#FILE_POSTGRE_CONFIG=scripts/postgresql_config.conf                      #PostgreSQL Configuration file with edited configuration, its difference with default file will be applied as patch to default file.
FILE_DEFAULT_STYLE=default.style

#These variables defines the scripts that are being used.
#FILE_SCRIPT_OSMDATA=osmdata.sh     
FILE_POSTGRE_DB=scripts/postgres_db_config.sh
FILE_REPLACE_AND_DOWNLOAD=scripts/replace_and_download.py
FILE_DEFAULT_FILE_STYLE=default.style
#SCRIPT_OSM2PGSQL=osm2pgsql.sh
SCRIPT_RUNMAP=run_map.sh
SCRIPT_GEN_MAP=scripts/generate_map.sh
SCRIPT_GENERATE_TILES=scripts/generate_tiles.sh

SET_MAPNIK_ENV=/usr/local/meramap/mapnik_tool/archive/set-mapnik-env
MAPNIK_ARCHIVE=/usr/local/meramap/mapnik_tool/archive/


PATH_MERAMAP=/var/www/customise_meramap

PATH_OF_TILE=/var/www/CUSTOMISE_OSMAP/9

SYM_LINK=/var/www/CUSTOMISE_OSMAP
TILES=/usr/local/meramap/customise_map/daemon/main/scripts/tiles
