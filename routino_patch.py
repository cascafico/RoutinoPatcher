import telepot
import os
import time
import random
import datetime
bot = telepot.Bot('<your telegram token here')
bboxwidth = 0.01

def handle(msg):
    print(msg)
    lat = msg['location']['latitude']
    lon = msg['location']['longitude']
    print repr(lat) + ',' + repr(lon)
    latmin = lat - bboxwidth
    latmax = lat + bboxwidth
    lonmin = lon - bboxwidth
    lonmax = lon + bboxwidth
    bbox      = repr(latmin) +','+ repr(lonmin) + ',' + repr(latmax) +','+ repr(lonmax)   
    bboxtutto = repr(lonmin) +','+ repr(latmin) + ',' + repr(lonmax) +','+ repr(latmax)   
    adesso = datetime.datetime.now().strftime('%H%M%S')

    bashCommandDownload = "wget -O " + "/home/pi/py/" + adesso + ".osm \"https://overpass-api.de/api/map?bbox=" + bboxtutto + "\""
    if isinstance(lat,float):
       os.system(bashCommandDownload)
       time.sleep(10)
       os.system("/home/pi/scripts/routino_patch.sh")
       os.system("touch %s" % lat % lon)
       print bashCommandDownload


bot.message_loop(handle, run_forever=True)
