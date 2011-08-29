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
MERAMAP_API=/usr/local/meramap-api     # MeraMap Directory in User's System

LOGFILE_INST=$MERAMAP_API/logfiles/install.log
LOGFILE_SRV=$MERAMAP_API/logfiles/server.log


API_DOMAIN=meramap-api.org
DBUSER=openstreetmap
DBPASS=1234

# Hartlepool, UK (also known as the Bright Centre of the Universe)
MINLON=-1.311
MINLAT=54.608
MAXLON=-1.111
MAXLAT=54.729

RAILSDIR=$MERAMAP_API/rails
PATH_GPX_TRACES=$MERAMAP_API/gpx/traces
PATH_GPX_IMAGES=$MERAMAP_API/gpx/images
