#!/bin/sh

BUILDDIR=mapnik2
PREFIX=/usr
DEBDIR=mapnik2-deb
CONTDIR=DEBIAN        #directory for debian control file
BASEDIR=`pwd`
PYTHONVER=`python --version 2>&1 | cut -f2 -d' ' | cut -f1,2 -d'.'`

echo $PYTHONVER

#
# First compile and build mapnik into our DEBDIR directory.
#
cd $BASEDIR/$BUILDDIR
echo "Configure Mapnik2...."
#python scons/scons.py configure \
#    PREFIX=$BASEDIR/$DEBDIR$PREFIX \
#    PYTHON_PREFIX=$BASEDIR/$DEBDIR$PREFIX
echo "Compile Mapnik2....."
#python scons/scons.py 
echo "Install Mapnik2....."
#python scons/scons.py install


#
# Now the configuration files have absolute paths to the DEBDIR directory
# but when installed, this will become the root directory.
# This means we have to strip off the DEBDIR prefix from these files.
# We do this using sed....
#
echo "Correct configuration files...."
for file in $BASEDIR/$DEBDIR$PREFIX/lib/pkgconfig/mapnik2.pc \
    $BASEDIR/$DEBDIR$PREFIX/bin/mapnik-config \
    $BASEDIR/$DEBDIR$PREFIX/lib/python$PYTHONVER/site-packages/mapnik2/paths.py
do
    echo Correcting $file .....
    mv $file /tmp/infile
    SEDCMD=s_${BASEDIR}/${DEBDIR}__
    echo $SEDCMD
    sed $SEDCMD /tmp/infile >$file
done;

#
# We should now have built the file structure that needs to be installed in
#    $BASEDIR/$DEBDIR$PREFIX.
# Now we need to create the debian control files and make it into a debian 
#    package archive.
#
DEPS="libboost-filesystem1.42.0,
      libboost-iostreams1.42.0, 
      libboost-program-options1.42.0, 
      libboost-python1.42.0, 
      libboost-regex1.42.0, 
      libboost-system1.42.0, 
      libboost-thread1.42.0, 
      python(>=2.6), 
      libxml2, 
      libfreetype6, 
      libjpeg62, 
      libltdl7, 
      libpng12-0, 
      libgeotiff1.2, 
      libtiff4, 
      libtiffxx0c2, 
      libcairo2, 
      python-cairo, 
      libcairomm-1.0-1, 
      ttf-unifont, 
      ttf-dejavu, 
      ttf-dejavu-core, 
      ttf-dejavu-extra, 
      libgdal1-1.6.0, 
      python-gdal, 
      libsqlite3-0 "

CONTPATH=$BASEDIR/$DEBDIR/$CONTDIR/control
mkdir -p $BASEDIR/$DEBDIR/$CONTDIR
if [ -e $CONTPATH ]; then 
  rm $CONTPATH
fi

SVNREV=`svn info | grep "Last Changed Rev:" | cut -d' ' -f4`
echo SVNREV=$SVNREV
echo "Package: mapnik2" > $CONTPATH
echo "Version: "$SVNREV >> $CONTPATH
echo "Architecture: i386" >> $CONTPATH
echo "Depends: "$DEPS >> $CONTPATH
echo "Maintainer: Graham Jones (grahamjones139@gmail.com)" >> $CONTPATH
echo "Description: Mapnik2 libary and python dependencies" >> $CONTPATH
#for dep in $DEPS
#do
#  echo -n $dep | cut -d\n -f1  >> $BASEDIR/$DEBDIR/control
#  #pkg=`dpkg -S $dep | head -1`
#  #echo $dep"...."$pkg
#  #pkg2=`sudo apt-cache search $dep | head -1`
# # #echo "apt-cache $dep...."$pkg2
#  #echo "......"
#  echo -n ", "  >> $BASEDIR/$DEBDIR/control
#done;


#
# Now build the package
#
dpkg-deb --build $BASEDIR/$DEBDIR