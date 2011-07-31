#!/bin/bash
source scripts/variable.sh

#if [ -e $MERAMAP_DEB  ]; then rm $MERAMAP_DEB; fi #To check to If meramap.deb

#wget https://github.com/ParveenArora/MeraMap/raw/master/meramap.deb

#sudo dpkg -i meramap.deb 
#sudo apt-get install -f 

if [ -e $LOGFILE_INST ]; then rm $LOGFILE_INST; fi #To check for log file If already exists or not. If it already exists then it will delete the previous log file. 
echo $0 >> $LOGFILE_INST 2>&1 
#sudo apt-get install apache2

#sudo dpkg -i meramap.deb >> $LOGFILE_INST 2>&1  #This debian package is to install all the required dependencies and packages require, all the names of dependencies and packages can be found in the control file of this debian package.
#sudo apt-get install -f
#sudo /etc/init.d/apache2 restart #>> $LOGFILE_INST 2>&1    #To restart apache

./scripts/$FILE_POSTGRE_PATCH >> $LOGFILE_INST 2>&1         #Script to apply required configuration to user's default configuration of PostGreSQL.
su -c ./scripts/$FILE_POSTGRE_DB >> $LOGFILE_INST 2>&1            #Script to check the version of ubuntu, to create database and user of postgresql and to enable creatlang.
./scripts/$SCRIPT_OSM2PGSQL >> $LOGFILE_INST 2>&1           #Script to load osm data into pgsql.
./scripts/$SCRIPT_GENERATE_TILES >> $LOGFILE_INST 2>&1      #Script to generate map tiles.

./scripts/$SCRIPT_GEN_MAP                                   #script to show map on web browser. 
