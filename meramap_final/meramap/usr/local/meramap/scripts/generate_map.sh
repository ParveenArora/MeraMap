#!/bin/bash
source scripts/variable.sh

#if [ -d $PATH_MERAMAP ]; then rm -r $PATH_MERAMAP; fi

#sudo cp -r map /var/www/meramap/

if [ -d $SYM_LINK ]; then rm $SYM_LINK; fi

sudo ln -s $TILES $SYM_LINK

if [ -d $CUSTOM_TILES_LINK ]; then sudo rm -rf $ $CUSTOM_TILES_LINK; fi

sudo ln -s $CUSTOM_TILES $CUSTOM_TILES_LINK




if [ -d $PATH_OF_TILE ]; then echo "Congratulations, You Can check your Map Working at http://localhost/map/"; fi

