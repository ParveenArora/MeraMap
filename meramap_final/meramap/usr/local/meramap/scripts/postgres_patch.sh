#!/bin/bash
source scripts/variable.sh
echo "*********************************************"
echo "* Configuring PostgreSQL Configuration FIle *"
echo "*********************************************"
#wget https://raw.github.com/ParveenArora/MeraMap/master/configuration_files/postgresql_config.conf

echo "Creating patch............... "
diff -u $FILE_POSTGRE_PATH $FILE_POSTGRE_CONFIG > $FILE_PATCH
echo "Applying Patch.............. "
patch $FILE_POSTGRE_PATH < $FILE_PATCH
sudo sh -c "echo 'kernel.shmmax=268435456' > /etc/sysctl.d/60-shmmax.conf"
sudo service procps start
sudo /etc/init.d/postgresql restart
echo done
