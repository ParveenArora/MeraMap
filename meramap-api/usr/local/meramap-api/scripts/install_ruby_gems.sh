#!/bin/sh
echo "install_ruby_gems.sh - Installing ruby_gems......"
SCRIPTDIR="$( cd -P "$( dirname "$0" )" && pwd )"
source $SCRIPTDIR/variables.sh

echo "Creating downlods directory in "$MERAMAP_API
mkdir -p $MERAMAP_API/downloads
cd $MERAMAP_API/downloads

echo "Downloading rubgems source code...."
wget http://files.rubyforge.vm.bytemark.co.uk/rubygems/rubygems-1.3.7.tgz

echo "Extracting files from archive...."
tar -xzf rubygems-1.3.7.tgz 

echo "Configuring Ruby Gems...."
cd $MERAMAP_API/downloads/rubygems-1.3.7/
ruby setup.rb 
ln -s /usr/bin/gem1.8 /usr/bin/gem

echo "install_ruby_gems.sh complete!!"