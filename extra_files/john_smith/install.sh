#!/bin/bash

rm -f /usr/share/zoneinfo/poxix /usr/share/zoneinfo/right
apt-get -y install hostname unzip bzip2 nano osm2pgsql python-mapnik subversion postgresql-contrib-8.4 postgresql-8.4-postgis curl imagemagick rsync php5-cli
mkdir -p /etc/mapnik-osm-data/world_boundaries
cd /etc/mapnik-osm-data/
wget -c http://www.archive.org/download/SharedMap2/default.style -O /usr/share/default.style
wget -c http://tile.openstreetmap.org/world_boundaries-spherical.tgz
tar xvzf world_boundaries-spherical.tgz
wget -c http://tile.openstreetmap.org/processed_p.tar.bz2
tar xvjf processed_p.tar.bz2 -C world_boundaries
wget -c http://tile.openstreetmap.org/shoreline_300.tar.bz2
tar xjf shoreline_300.tar.bz2 -C world_boundaries
wget -c http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/110m-admin-0-boundary-lines.zip
unzip 110m-admin-0-boundary-lines.zip -d world_boundaries
wget -c http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/10m-populated-places.zip
unzip 10m-populated-places.zip -d world_boundaries
su - postgres -c 'createuser -s root'
createdb gis
createlang plpgsql gis
psql -d gis -f /usr/share/postgresql/8.4/contrib/hstore.sql
psql -d gis -f /usr/share/postgresql/8.4/contrib/postgis-1.5/postgis.sql
psql -d gis -f /usr/share/postgresql/8.4/contrib/postgis-1.5/spatial_ref_sys.sql
psql -d gis -f /usr/share/postgresql/8.4/contrib/_int.sql
wget -c http://ftp.au.debian.org/debian/pool/main/o/osm2pgsql/osm2pgsql_0.70.5+r25090-2+b1_i386.deb \
     http://ftp.au.debian.org/debian/pool/main/g/geos/libgeos-3.2.2_3.2.2-1_i386.deb \
     http://ftp.au.debian.org/debian/pool/main/p/protobuf-c/libprotobuf-c0_0.14-1+b1_i386.deb
dpkg -i libgeos-3.2.2_3.2.2-1_i386.deb libprotobuf-c0_0.14-1+b1_i386.deb osm2pgsql_0.70.5+r25090-2+b1_i386.deb
rm libgeos-3.2.2_3.2.2-1_i386.deb libprotobuf-c0_0.14-1+b1_i386.deb osm2pgsql_0.70.5+r25090-2+b1_i386.deb
wget -c http://m.m.i24.cc/osmconvert32 -O /usr/bin/osmconvert
wget -c http://www.archive.org/download/SharedMap2/osmosis -O /usr/bin/osmosis
chmod 755 /usr/bin/osmconvert /usr/bin/osmosis
cd /usr/src
svn co http://svn.openstreetmap.org/applications/rendering/mapnik
cd mapnik
./generate_xml.py --dbname gis --user root --accept-none --world_boundaries=/etc/mapnik-osm-data/world_boundaries
cp -a osm.xml inc symbols /etc/mapnik-osm-data/

#wget -c http://download.geofabrik.de/osm/central-america.osm.pbf -O /root/central-america.osm.pbf
#wget -c http://download.geofabrik.de/osm/south-america.osm.pbf -O /root/south-america.osm.pbf
#
#osmconvert central-america.osm.pbf --drop-history --out-o5m > ca.o5m
#osmconvert south-america.osm.pbf --drop-history --out-o5m > sa.o5m
#osmconvert ca.o5m sa.o5m -b=-82.5,-57,-34,13 --drop-brokenrefs --out-o5m > csa.o5m
#
#/usr/bin/osmosis --rrii makeExpiryList=true boundingBox=-82.5,-57,-34,13
#/usr/bin/osmosis --get-state-file 2011-05-31T00:00:00Z
#echo "*/10 *  * * *   root    /usr/bin/osmosis --rri" >> /etc/crontab
