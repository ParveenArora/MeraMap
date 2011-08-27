#!/bin/sh
# Installs the ubuntu packages required for meramap-api.
# Note that this script is provided for development - when deployed
# apt or dpkg will require the correct packages.
# GJ 27aug2011
apt-get install apache2 subversion autoconf screen postgresql-8.4-postgis postgresql-contrib-8.4 postgresql-server-dev-8.4 build-essential libxml2-dev libtool libxml2-dev libgeos-dev libbz2-dev proj osm2pgsql libltdl3-dev libpng12-dev libtiff4-dev libicu-dev libboost-python1.40-dev python-cairo-dev python-nose libboost1.40-dev libboost-filesystem1.40-dev libboost-iostreams1.40-dev libboost-regex1.40-dev libboost-thread1.40-dev libboost-program-options1.40-dev libboost-python1.40-dev libfreetype6-dev libcairo2-dev libcairomm-1.0-dev libgeotiff-dev libtiff4 libtiff4-dev libtiffxx0c2 libsigc++-dev libsigc++0c2  libsigx-2.0-2 libsigx-2.0-dev libgdal1-dev python-gdal imagemagick ttf-dejavu python-mapnik libmapnik0.7 ruby1.8 rdoc1.8 ri1.8 ruby irb libxslt1-dev ruby1.8-dev apache2-dev libmagick9-dev build-essential libopenssl-ruby osmosis
