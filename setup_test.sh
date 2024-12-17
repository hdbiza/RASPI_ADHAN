#!/bin/bash

echo "{ \"time\":\"$(date +%H:%M)\", \"adhan\" :{\"Fajr\":\"$(date --date='+5 minutes' +%H:%M)\", \"Dhuhr\":\"$(date --date='+10 minutes' +%H:%M)\", \"Asr\":\"$(date --date='+15 minutes' +%H:%M)\", \"Maghrib\":\"$(date --date='+20 minutes' +%H:%M)\", \"Isha\":\"$(date --date='+25 minutes' +%H:%M)\"}}" > /var/www/html/index.html
