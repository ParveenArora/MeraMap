cd ~
wget http://202.164.53.116/~parveen/mm/meramap.tar.gz
tar -zxvf meramap.tar.gz
sudo apt-get update
sudo apt-get upgrade
cd subversion
sudo dpkg -i subversion_1.6.6dfsg-2ubuntu1.*.*
sudo apt-get install autoconf screen munin-node munin htop
cd ~
mkdir src bin planet
cd postgresql
sudo dpkg -i *.*


cd ~/bin/osm2pgsql
./autogen.sh
./configure
make


sudo rm /etc/postgresql/8.4/main/postgresql.conf
sudo cp configuration_files/posgresql.conf /etc/postgresql/8.4/main/postgresql.conf

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

sudo apt-get install libltdl3-dev libpng12-dev libtiff4-dev libicu-dev
sudo apt-get install libboost-python1.40-dev python-cairo-dev python-nose
sudo apt-get install libboost1.40-dev libboost-filesystem1.40-dev
sudo apt-get install libboost-iostreams1.40-dev libboost-regex1.40-dev libboost-thread1.40-dev
sudo apt-get install libboost-program-options1.40-dev libboost-python1.40-dev
sudo apt-get install libfreetype6-dev libcairo2-dev libcairomm-1.0-dev
sudo apt-get install libgeotiff-dev libtiff4 libtiff4-dev libtiffxx0c2
sudo apt-get install libsigc++-dev libsigc++0c2 libsigx-2.0-2 libsigx-2.0-dev
sudo apt-get install libgdal1-dev python-gdal
sudo apt-get install imagemagick ttf-dejavu

cd ~/bin/mapnik
tar xvzf world_boundaries-spherical.tgz
tar xvjf processed_p.tar.bz2 -C world_boundaries
tar xjf shoreline_300.tar.bz2 -C world_boundaries
unzip 10m-populated-places.zip -d world_boundaries
unzip 110m-admin-0-boundary-lines.zip -d world_boundaries

cd ~/bin/mapnik
sudo rm generate_image.py
sudo cp ~/mm/configuration_files/generate_image.py ~/bin/mapnik/

./generate_xml.py --dbname gis --user username --accept-none
./generate_image.py

sudo apt-get install sun-java6-jdk
wget http://gweb.bretth.com/osmosis-latest.tar.gz
tar xvfz osmosis-latest.tar.gz
cd osmosis-0.*

./bin/osmosis --read-xml /home/'whoami'/india.osm.gz --bounding-box left=-94 bottom=38 right=-71.5 top=50 --write-xml ~/GreatLakes.osm.gz
rm ~/bin/mapnik/archive/set-mapnik-env
cd 
cd mm/configuration_files
sudo cp set-mapnik-env ~/bin/mapnik/archive
cp z1_generate_tiles.py ~/bin/mapnik
cd ~/bin/mapnik/archieve
source set-mapnik-env
./customize-mapnik-map >$MAPNIK_MAP_FILE
cd ..
./z1_generate_tiles.py












