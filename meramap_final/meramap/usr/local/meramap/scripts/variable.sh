#!/bin/bash#!/bin/bash
#This file contains all the variables using in all the files

#This is meramap directory in user's system
MERAMAP=/usr/local/meramap     # MeraMap Directory in User's System
DOWNLOAD=/home/parveen/Desktop

MERAMAP_SCRIPT=/usr/local/meramap/scripts   #Meramap Scripts Directory

#Variables which are defineing log files. These all log files will be in the /usr/local/meramap
LOGFILE=/usr/local/meramap/logfiles/postgres_meramap.log       #Log file to which includes all the 
LOGFILE_OSM2PGSQL=/usr/local/meramap/logfiles/osm2pgsql.log    #Log file to load osm data into pgsql 
LOGFILE_INST=/usr/local/meramap/logfiles/meramap.log           #Whole Installation Log File
LOGFILE_TILES=/usr/local/meramap/logfiles/tiles.log    
LOGFILE_OSMOSIS=logfiles/osmosis.log

#Variables Defining Database Username and Database Name
DBNAME=meramap_dba                 #PostgreSQL Database Name
DBUSER=meramap_user                #PosrgreSQL Database Username 

#This is the command to know the verison of ubuntu being used by the user.
UBUNTUVERSION=`lsb_release -r | cut -f2`     

#This variables are defining path to directories.
PLANET=planet
BIN=bin
#PUBLIC_HTML=~/public_html     #Direcory from where the map will work, Map folder will be placed in this dorectory.

#These variables are to files with there path
FILE_OSMDATAFILE=map_data/ludhiana.osm.bz2                        #Ludhiana's OSM Data file, only to run the system
FILE_POSTGRE_PATH=/etc/postgresql/8.4/main/postgresql.conf      #PostgreSQL Configuration File
FILE_POSTGRE_CONFIG=scripts/postgresql_config.conf                      #PostgreSQL Configuration file with edited configuration, its difference with default file will be applied as patch to default file.
FILE_DEFAULT_STYLE=/usr/share/osm2pgsql/osm2pgsql/default.style

#These variables defines the scripts that are being used.
#FILE_SCRIPT_OSMDATA=osmdata.sh     
FILE_POSTGRE_DB=postgres_db_config.sh
FILE_PATCH=scripts/postgresql.patch
FILE_POSTGRE_PATCH=postgres_patch.sh
FILE_DEFAULT_FILE_STYLE=default.style
SCRIPT_OSM2PGSQL=osm2pgsql.sh
#SCRIPT_MAPNIK_TOOLS=mapnik_tools.sh
#SCRIPT_MAPNIK_TILES=mapnik_tiles.sh
SCRIPT_RUNMAP=run_map.sh
SCRIPT_GEN_MAP=generate_map.sh
SCRIPT_GENERATE_TILES=generate_tiles.sh

SET_MAPNIK_ENV=mapnik_tool/archive/set-mapnik-env
MAPNIK_ARCHIVE=mapnik_tool/archive/

MERAMAP_DEB=meramap.deb

PATH_MERAMAP=/var/www/meramap

PATH_OF_TILE=/var/www/OSMAP/9

#**********Links*************

SYM_LINK=/var/www/OSMAP
TILES=/usr/local/meramap/mapnik_tool/tiles

CUSTOM_LINK=/var/www/customise_map

CUSTOM_TILES=/usr/local/meramap/mapnik_tool/customise_tiles
CUSTOM_TILES_LINK=/var/www/CUSTOM_TILES

#**************************************



#OSMOSIS
#**********************************************

if [ ! -f $FILE_DEFAULT_STYLE ];
then
    FILE_DEFAULT_STYLE=$MERAMAP_SCRIPT/../$FILE_DEFAULT_FILE_STYLE
fi
OSM2PG=/usr/bin/osm2pgsql
OSM_USER=root
OSMIOS_CHANGES=changes.osc.gz
WORKDIR_OSM=$MERAMAP/osmosis/.osmosis
OSMOSIS=$WORKDIR_OSM/../bin/osmosis
OSMOSIS_AREA_FILE=/usr/local/meramap/customise_map/daemon/main/area.txt

LOGFOLDER=/usr/local/meramap/logfiles
#************************************************************
