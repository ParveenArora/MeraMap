#!/bin/bash
source $MERAMAP_SCRIPT/variables.sh
echo "*********************************************"
echo "* Configuring PostgreSQL Configuration FIle *"
echo "*********************************************"
#wget https://raw.github.com/ParveenArora/MeraMap/master/configuration_files/postgresql_config.conf

echo "Creating patch............... "
diff -u $FILE_POSTGRE_PATH $MERAMAP_SCRIPT/$FILE_POSTGRE_CONFIG > $MERAMAP_SCRIPT/$FILE_PATCH
echo "Applying Patch.............. "
patch $FILE_POSTGRE_PATH < $MERAMAP_SCRIPT/$FILE_PATCH
sudo sh -c "echo 'kernel.shmmax=268435456' > /etc/sysctl.d/60-shmmax.conf"
sudo service procps start
sudo /etc/init.d/postgresql-8.4 restart
