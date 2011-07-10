#!/bin/sh
echo "Configuring Default Postgresql.conf"
echo "Creating Patch"
diff -u /etc/postgresql/8.4/main/postgresql.conf /configuration_files/settings_postgresql.conf > postgresql.patch
echo "Apply patch.............. "
patch /etc/postgresql/8.4/main/postgresql.conf < postgresql.patch
echo "Done, Change are made in original File"
