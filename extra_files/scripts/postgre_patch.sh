#!/bin/sh
source variables.sh
echo "*********************************************"
echo "* Configuring PostgreSQL Configuration FIle *"
echo "*********************************************"
#wget https://raw.github.com/ParveenArora/MeraMap/master/configuration_files/postgresql_config.conf

echo "Creating patch............... "
diff -u $FILE_POSTGRE_PATH $FILE_POSTGRE_CONFIG > $FILE_PATCH
echo "Applying Patch.............. "
patch $FILE_POSTGRE_PATH < $FILE_PATCHs
echo "Done"
