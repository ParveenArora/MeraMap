#!/bin/bash
source variable.sh
sudo cp -r bin ~/

if [ -d $PATH_MERAMAP ]; then sudo rm -rf $PATH_MERAMAP; fi

sudo cp -r meramap /var/www

if [ -d $SYM_LINK ]; then sudo rm $SYM_LINK; fi

sudo ln -s ~/bin/mapnik/tiles $SYM_LINK

if [ -d $PATH_OF_TILE ]; then echo "Congratulations, You Can check your Map Working at http://localhost/meramap"; fi

