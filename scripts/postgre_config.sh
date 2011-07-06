#!/bin/sh
echo "*********************************************"
echo "* Configuring PostgreSQL Configuration FIle *"
echo "*********************************************"
wget https://raw.github.com/ParveenArora/MeraMap/master/configuration_files/postgresql_config.conf
echo "Creating patch............... "
diff -u /etc/postgresql/8.4/main/postgresql.conf postgresql_config.conf > postgresql.patch
echo "Applying Patch.............. "
patch /etc/postgresql/8.4/main/postgresql.conf < postgresql.patch
echo "Done"
