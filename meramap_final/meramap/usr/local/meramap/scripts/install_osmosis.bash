#!/bin/bash
#Required Debian Packages: sun-java6-jdk unzip

#If you build the package, please call wget http://toolserver.org/~mazder/replicate-sequences/?2011-07-01T10:00:00Z -O $WORKDIR_OSM/state.txt with the correct date

source /usr/local/meramap/scripts/variable.sh
if [ ! -d $WORKDIR_OSM ]; then
	mkdir $WORKDIR_OSM;
fi
cd $WORKDIR_OSM/..

if [ ! -f $FILE_DEFAULT_STYLE ]; then
    FILE_DEFAULT_STYLE=$MERAMAP_SCRIPT/../$FILE_DEFAULT_FILE_STYLE
fi

#If the configuration is present, osmosis is already installed
if [ -f $WORKDIR_OSM/configuration.txt ]; then
	echo "configuration.txt is already installed" &>> $MERAMAP/$LOGFILE_OSMOSIS
else
	sudo -u $OSM_USER $OSMOSIS --read-replication-interval-init workingDirectory=$WORKDIR_OSM &>> $MERAMAP/$LOGFILE_OSMOSIS
fi

#Set up tiles generation every week
echo "#!/bin/sh
#This is part of the meramap package

$MERAMAP_SCRIPT/generate_tiles.sh
" > /etc/cron.weekly/generate_tiles.sh
chmod 755 /etc/cron.weekly/generate_tiles.sh

#Set up runlevels to start osmosis on startup
update-rc.d osmosis defaults &>> $MERAMAP/$LOGFILE_OSMOSIS
