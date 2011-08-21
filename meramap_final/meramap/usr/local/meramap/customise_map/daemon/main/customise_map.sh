#!/bin/bash

echo Content-type: text/html
echo

./main.sh > /var/www/tmp/Process.txt &

date

echo "See progress at http://localhost/tmp/Proces.txt !!!"
echo  " and Wait Process complete..........
