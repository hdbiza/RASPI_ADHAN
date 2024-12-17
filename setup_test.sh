#!/bin/bash

echo "{ \"time\":\"$(date +%H:%M)\", \"adhan\" :{\"Fajr\":\"$(date --date='+1 minutes' +%H:%M)\", \"Dhuhr\":\"$(date --date='+2 minutes' +%H:%M)\", \"Asr\":\"$(date --date='+3 minutes' +%H:%M)\", \"Maghrib\":\"$(date --date='+4 minutes' +%H:%M)\", \"Isha\":\"$(date --date='+5 minutes' +%H:%M)\"}}" > /var/www/html/index.html
