#!/bin/sh

# run by telegram bot (see routino_patcher.py)
# it updates an 0.02x0.02 degree area to be routed by routino software.

# planetsplitter doesn't like the following tags
sed -i -e '/<note>/d' -e '/<meta/d'   /home/pi/py/*.osm

# map centered on first location
cd /home/pi/py
maxlat=`cat *osm | grep " lat=" | awk -F "lat=" '/1/ {print $2}' | awk -F "\"" '/1/ {print $2}' | sort -k1 -n | tail -1`
maxlon=`cat *osm | grep " lat=" | awk -F "lat=" '/1/ {print $2}' | awk -F "\"" '/1/ {print $4}' | sort -k1 -n | tail -1`
minlat=`cat *osm | grep " lat=" | awk -F "lat=" '/1/ {print $2}' | awk -F "\"" '/1/ {print $2}' | sort -k1 -n | head -1`
minlon=`cat *osm | grep " lat=" | awk -F "lat=" '/1/ {print $2}' | awk -F "\"" '/1/ {print $4}' | sort -k1 -n | head -1`

# map center based on .osm extremes
cd /var/www/html/routino/www/routinopatch
sed -i -e '/westedge:/c\westedge: '"$minlon"',' /var/www/html/routino/www/routinopatch/mapprops.js
sed -i -e '/eastedge:/c\eastedge: '"$maxlon"',' /var/www/html/routino/www/routinopatch/mapprops.js
sed -i -e '/southedge:/c\southedge: '"$minlat"',' /var/www/html/routino/www/routinopatch/mapprops.js
sed -i -e '/northedge:/c\northedge: '"$maxlat"',' /var/www/html/routino/www/routinopatch/mapprops.js

cd /var/www/html/routino/datapatch
rm /tmp/*.tmp
/var/www/html/routino/bin/planetsplitter --tmpdir=/tmp --prefix=patch /home/pi/py/*.osm


/home/pi/apps/tg/bin/telegram-cli -W -e "msg @RoutinoBot routing database updated: try routing at http://bit.ly/routinobot"                   
