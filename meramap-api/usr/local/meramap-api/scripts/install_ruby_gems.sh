#!/bin/sh
echo "install_ruby_gems.sh - Installing ruby_gems......"
SCRIPTDIR="$( cd -P "$( dirname "$0" )" && pwd )"
echo "scriptdir = $SCRIPTDIR"
. $SCRIPTDIR/variables.sh

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

#Now installing specific gems (libraries)....
echo "Installing rails..."
gem install -v=2.3.14 rails
echo "installing timecop..." 
gem install timecop
echo "installing pg..."
gem install pg
echo "installing ruby-openid..."
gem install ruby-openid
echo "installing rack-openid..."
gem install rack-openid
echo "installing oauth...."
gem install oauth

echo "install_ruby_gems.sh complete!!"