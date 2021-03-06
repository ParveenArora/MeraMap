#!/bin/sh
############################################################################
#    Copyright 2011 Graham Jones
#
#    This file is part of Meramap-api.
#
#    Meramap-api is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    Meramap-api is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with Meramap-api.  If not, see <http://www.gnu.org/licenses/>.
############################################################################
#
# Installs the ubuntu packages required for meramap-api.
# Note that this script is provided for development - when deployed
# apt or dpkg will require the correct packages.
# GJ 27aug2011
apt-get install apache2 subversion autoconf screen postgresql-8.4-postgis postgresql-contrib-8.4 postgresql-server-dev-8.4 build-essential libxml2-dev libtool libxml2-dev libgeos-dev libbz2-dev proj libsigc++-dev libsigc++0c2  libsigx-2.0-2 libsigx-2.0-dev libgdal1-dev imagemagick ruby1.8 rdoc1.8 ri1.8 ruby irb libxslt1-dev ruby1.8-dev apache2-dev libmagick9-dev build-essential libopenssl-ruby sendmail libarchive-dev
