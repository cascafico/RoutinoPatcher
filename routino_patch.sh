#!/bin/sh

# script eseguito da bot telegram per aggionare un patch da 0.02x0.02 gradi

# rimuovo i tag note e meta che non piacciono  a planetsplitter
sed -i -e '/<note>/d' -e '/<meta/d'   /home/pi/py/*.osm

# centro la visualizzazione mappa alla prima coordinata
cd /home/pi/py
maxlat=`cat *osm | grep " lat=" | awk -F "lat=" '/1/ {print $2}' | awk -F "\"" '/1/ {print $2}' | sort -k1 -n | tail -1`
maxlon=`cat *osm | grep " lat=" | awk -F "lat=" '/1/ {print $2}' | awk -F "\"" '/1/ {print $4}' | sort -k1 -n | tail -1`
minlat=`cat *osm | grep " lat=" | awk -F "lat=" '/1/ {print $2}' | awk -F "\"" '/1/ {print $2}' | sort -k1 -n | head -1`
minlon=`cat *osm | grep " lat=" | awk -F "lat=" '/1/ {print $2}' | awk -F "\"" '/1/ {print $4}' | sort -k1 -n | head -1`

# centro la mappa con gli estremi ricavati dagli *osm
cd /var/www/html/routino/www/routinopatch
sudo -u www-data sed -i -e '/westedge:/c\westedge: '"$minlon"',' /var/www/html/routino/www/routinopatch/mapprops.js
sudo -u www-data sed -i -e '/eastedge:/c\eastedge: '"$maxlon"',' /var/www/html/routino/www/routinopatch/mapprops.js
sudo -u www-data sed -i -e '/southedge:/c\southedge: '"$minlat"',' /var/www/html/routino/www/routinopatch/mapprops.js
sudo -u www-data sed -i -e '/northedge:/c\northedge: '"$maxlat"',' /var/www/html/routino/www/routinopatch/mapprops.js

cd /var/www/html/routino/datapatch
sudo -u www-data rm /tmp/*.tmp
sudo -u www-data /var/www/html/routino/bin/planetsplitter --tmpdir=/tmp --prefix=patch /home/pi/py/*.osm


/home/pi/apps/tg/bin/telegram-cli -W -e "msg @RoutinoBot routing database aggiornato: prova la navigazione su http://bit.ly/routinobot"                   
