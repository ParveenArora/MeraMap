#!bin/bash
source variables.sh
if [ -d $PUBLIC_HTML ];
then
    cp -r map $PUBLIC_HTML
else
    mkdir public_html
    cd /etc/apache2/mods-enabled
    sudo ln -s ../mods-available/userdir.conf userdir.conf
    sudo ln -s ../mods-available/userdir.load userdir.load
    sudo /etc/init.d/apache2 restart
fi
cp -r map $PUBLIC_HTML
firefox http://localhost/
