#!/bin/sh
MERAMAP_API=/usr/local/meramap-api     # MeraMap Directory in User's System

LOGFILE_INST=$MERAMAP_API/logfiles/install.log
LOGFILE_SRV=$MERAMAP_API/logfiles/server.log

RAILSDIR=$MERAMAP_API/rails

PATH_GPX_TRACES=$MERAMAP_API/gpx/traces
PATH_GPX_IMAGES=$MERAMAP_API/gpx/images

DBUSER=openstreetmap
DBPASS=1234

# Hartlepool, UK (also known as the Bright Centre of the Universe)
MINLON=-1.311
MINLAT=54.608
MAXLON=-1.111
MAXLAT=54.729