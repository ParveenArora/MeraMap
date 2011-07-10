#!/bin/bash
source variables.sh
echo "*********************************************"
echo "* Configuring PostgreSQL Configuration FIle *"
echo "*********************************************"
#wget https://raw.github.com/ParveenArora/MeraMap/master/configuration_files/postgresql_config.conf

echo "Creating patch............... "
diff -u $FILE_POSTGRE_PATH $MERAMAP/$FILE_POSTGRE_CONFIG >$MERAMAP/$FILE_PATCH
echo "Applying Patch.............. "
patch $FILE_POSTGRE_PATH < $MERAMAP/$FILE_PATCHs
sudo sh -c "echo 'kernel.shmmax=268435456' > /etc/sysctl.d/60-shmmax.conf"
sudo service procps start
sudo /etc/init.d/postgresql-8.4 restart
