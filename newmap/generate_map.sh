#!/bin/bash
source variable.sh
cp -r bin ~/
sudo cp -r meramap /var/www

sudo ln -s ~/bin/mapnik/tiles /var/www/OSM
echo "Congratulations, You Can check your Map Working at http://localhost/meramap" 

