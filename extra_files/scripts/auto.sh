sudo apt-get update
sudo apt-get upgrade
sudo apt-get install autoconf screen munin-node munin htop
cd ~/Desktop/mm/subversion
dpkg -i subversion_1.6.6dfsg-2ubuntu1.*.*
cd ~
mkdir src bin planet
cd ~/Desktop/mm/postgresql
dpkg -i postgresql*
cd osm2pgsql
/autogen.sh
./configure
make

sudo rm /etc/postgresql/8.4/main/postgresql.conf
cd ~/mm/configuration_files 
sudo cp postgresql.conf /etc/postgresql/8.4/main/
cd
sudo sh -c "echo 'kernel.shmmax=268435456' > /etc/sysctl.d/60-shmmax.conf"
sudo service procps start
sudo /etc/init.d/postgresql-8.4 restart

sudo -u postgres -i
createuser username # answer yes for superuser
createdb -E UTF8 -O username gis
createlang plpgsql gis
exit

psql -f /usr/share/postgresql/8.4/contrib/postgis-1.5/postgis.sql -d gis

echo "ALTER TABLE geometry_columns OWNER TO username; ALTER TABLE spatial_ref_sys OWNER TO username;" | psql -d gis

psql -f /usr/share/postgresql/8.4/contrib/_int.sql -d gis

psql -f ~/bin/osm2pgsql/900913.sql -d gis

cd ~/bin/osm2pgsql

./osm2pgsql -S default.style --slim -d gis -C 2048 ~/planet/india.osm.bz2





