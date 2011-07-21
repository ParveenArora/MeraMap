#!/bin/bash
source variable.sh
cp -r bin ~/

if [ -d $PATH_MERAMAP ]; then rm -r $PATH_MERAMAP; fi

sudo cp -r meramap /var/www

sudo ln -s ~/bin/mapnik/tiles /var/www/OSMAP


if [ -d $PATH_OF_TILE ]; then echo "Congratulations, You Can check your Map Working at http://localhost/meramap"; fi

