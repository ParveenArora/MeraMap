sudo apt-get update
sudo apt-get upgrade
sudo apt-get install subversion autoconf screen munin-node munin htop
cd ~
mkdir src bin planet
cd planet

http://download.geofabrik.de/osm/asia/india.osm.bz2
sudo apt-get install postgresql-8.4-postgis postgresql-contrib-8.4
sudo apt-get install postgresql-server-dev-8.4
sudo apt-get install build-essential libxml2-dev libtool
sudo apt-get install libgeos-dev libpq-dev libbz2-dev proj

cd ~/bin
svn co http://svn.openstreetmap.org/applications/utils/export/osm2pgsql/
cd osm2pgsql
./autogen.sh
./configure
make

sudo sh -c "echo 'kernel.shmmax=268435456' > /etc/sysctl.d/60-shmmax.conf"
sudo service procps start

sudo /etc/init.d/postgresql-8.4 restart





sudo -u postgres -i
createuser username # answer yes for superuser
createdb -E UTF8 -O username gis
createlang plpgsql gis
exit

psql -f /usr/share/postgresql/8.4/contrib/postgis.sql -d gis


echo "ALTER TABLE geometry_columns OWNER TO parveen; ALTER TABLE spatial_ref_sys OWNER TO parveen;" | psql -d gis


psql -f /usr/share/postgresql/8.4/contrib/_int.sql -d gis

echo "ALTER TABLE geometry_columns OWNER TO username; ALTER TABLE spatial_ref_sys OWNER TO username;" | psql -d gis

psql -f ~/bin/osm2pgsql/900913.sql -d gis

cd ~/bin/osm2pgsql

./osm2pgsql -S default.style --slim -d gis -C 2048 ~/planet/india.osm.bz2

sudo apt-get install libltdl3-dev libpng12-dev libtiff4-dev libicu-dev
sudo apt-get install libboost-python1.40-dev python-cairo-dev python-nose
sudo apt-get install libboost1.40-dev libboost-filesystem1.40-dev
sudo apt-get install libboost-iostreams1.40-dev libboost-regex1.40-dev libboost-thread1.40-dev
sudo apt-get install libboost-program-options1.40-dev libboost-python1.40-devt
sudo apt-get install libfreetype6-dev libcairo2-dev libcairomm-1.0-dev
sudo apt-get install libgeotiff-dev libtiff4 libtiff4-dev libtiffxx0c2
sudo apt-get install libsigc++-dev libsigc++0c2 libsigx-2.0-2 libsigx-2.0-dev
sudo apt-get install libgdal1-dev python-gdal
sudo apt-get install imagemagick ttf-dejavu

cd ~/src
svn co http://svn.mapnik.org/tags/release-0.7.1/ mapnik
cd mapnik
python scons/scons.py configure INPUT_PLUGINS=all OPTIMIZATION=3 SYSTEM_FONTS=/usr/share/fonts/truetype/
python scons/scons.py
sudo python scons/scons.py install
sudo ldconfig

cd ~/bin
svn co http://svn.openstreetmap.org/applications/rendering/mapnik


cd ~/bin/mapnik
mkdir world_boundaries
wget http://tile.openstreetmap.org/world_boundaries-spherical.tgz
tar xvzf world_boundaries-spherical.tgz
wget http://tile.openstreetmap.org/processed_p.tar.bz2
tar xvjf processed_p.tar.bz2 -C world_boundaries
wget http://tile.openstreetmap.org/shoreline_300.tar.bz2
tar xjf shoreline_300.tar.bz2 -C world_boundaries
wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/...
unzip 10m-populated-places.zip -d world_boundaries
wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/...
unzip 110m-admin-0-boundary-lines.zip -d world_boundaries

cd ~/bin/mapnik
./generate_xml.py --dbname gis --user username --accept-none
./generate_image.py

sudo apt-get install sun-java6-jdk

wget http://gweb.bretth.com/osmosis-latest.tar.gz
tar xvfz osmosis-latest.tar.gz
cd osmosis-0.*

./bin/osmosis --read-xml /home/username/planet-090311.osm.gz --bounding-box left=-94 bottom=38 right=-71.5 top=50 --write-xml /home/username/GreatLakes.osm.gz

time ./osm2pgsql --slim -d gis GreatLakes.osm.gz

export MAPNIK_DBNAME='osm'

cd ~/mapnik
cp generate_tiles.py z0_generate_tiles.py

source set-mapnik-env
./customize-mapnik-map >$MAPNIK_MAP_FILE
./z0_generate_tiles.py


