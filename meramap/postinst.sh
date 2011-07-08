#!/bin/bash
# NAME: postinst.sh
# DESC: This is the master file, All other scripts are included in it.
#       This script is part of MeraMap.
# HIST: 09July 2011   Original Version by Parveen Arora
#       
#     
source variables.sh
if [ -e $LOGFILE_INST ]; then rm $LOGFILE_INST; fi #To check for log file If already exists or not. If it already exists then it will delete the previous log file. 
echo $0 >> $LOGFILE_INST 2>&1   # To create a new log file named meramap.log.

./$FILE_SCRIPT_OSMDATA >> $LOGFILE_INST 2>&1   #This file check for the existence of planet folder in the home directory and planet file in that directory. If it already exists it will delete previous file and will replace it with the new one.
./$FILE_POSTGRE_PATCH >> $LOGFILE_INST 2>&1    #This files configures the setting of Installed postgresql, in the file postgresql.conf
./$FILE_POSTGRE_DB >> $LOGFILE_INST 2>&1       #This files configures the PostgreSQL Database, Create new user and databsse and enables postgis
./$SCRIPT_OSM2PGSQL >> $LOGFILE_INST 2>&1      # This file is to load osm data file into  pgsql using osm2pgsql. 
./$SCRIPT_MAPNIK_TOOLS >> $LOGFILE_INST 2>&1   #This file copeis the mapnik tools into bin direcory in the home of user.
./$SCRIPT_MAPNIK_TILES >> $LOGFILE_INST 2>&1   #This file is to genrate the tiles,  
./$SCRIPT_RUNMAP >> $LOGFILE_INST 2>&1         #This file will check for the existense of public_html in the user's home folder, If it doesn't exit there it will make the new one, and will enable user's home directory, and then will point to the browser where map is genrated. 




