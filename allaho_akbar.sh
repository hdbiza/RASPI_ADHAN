#!/bin/bash

API_URL=https://api.aladhan.com/v1/timings
LATITUDE=48.7824971
LONGITUDE=2.343032
METHOD=12
FOLDER=/home/ted/Desktop/ADHAN
LOG_FILENAME="logs/Traces_$(date '+%d%m%Y').log"
COMMAND_MB_START="$FOLDER/connect_mb.sh"
COMMAND_MB_END="$FOLDER/disconnect_mb.sh"
#COMMAND_VLC_FAJR="(pkill vlc;cvlc $(find $FOLDER/mp3/fajr_*.mp3 -type f | shuf -n 1) vlc://quit)"
#COMMAND_VLC_ADHAN="(pkill vlc;cvlc $(find $FOLDER/mp3/adhan_*.mp3 -type f | shuf -n 1) vlc://quit)"

Log() {
        printf '%s\n' "$@" >> $FOLDER/$LOG_FILENAME
}

Log "-------------------------------------------------------------"
Log '++++++++++++PROC CLEAN++++++++++++'
Log "Clean Current Adhan processes"
ps_command="ps -aux | grep vlc | grep -v grep | awk '{ print \$2 }'"
nb_ps_to_kill="$ps_command | wc -l | awk '{printf \$0}'"
Log "Number of processes to kill : $(eval $nb_ps_to_kill)"
[ $(eval $nb_ps_to_kill) -gt 0 ] && Log "kill in progress"
[ $(eval $nb_ps_to_kill) -gt 0 ] && kill -9 $(eval $ps_command) > /dev/null 2>&1

Log '++++++++++++FILE CLEAN++++++++++++'

ls -ltr $FOLDER/logs >> $FOLDER/$LOG_FILENAME
find $FOLDER/logs -name \"*.log\" -type f -mtime +10 -delete

Log '++++++++++++MAIN++++++++++++'
Log "Getting Final URL"
URL="$API_URL/$(date '+%d-%m-%Y')?latitude=$LATITUDE&longitude=$LONGITUDE&method=$METHOD"
Log "URL : $URL"

GetAdhanTime() {
	ADHAN=$1
	ADHAN_COMMAND="curl -sSL \"$URL\" | grep -o '\"$ADHAN\":\"[^\"]*' | grep -o '[^\"]*$'"
	#Log "$ADHAN_COMMAND"
	ADHAN_TIME=`eval $ADHAN_COMMAND`
	Log "$ADHAN Time For $ADHAN : $ADHAN_TIME"
	#ADHAN_TIME="23:59"
	echo "$ADHAN_TIME"
}


DecideAdhan(){
	ADHAN=$1
	ADHAN_TIME=$(GetAdhanTime $ADHAN)
	DIFF=`echo $(( $(date -d "$ADHAN_TIME" +%s) - $(date +%s) ))`
	Log "DIFF between $ADHAN and now is : $DIFF"
	[ $DIFF -gt 0 ] && Log "DIFF is positive"
	[ $DIFF -gt 0 ] && [ "$ADHAN" = "Fajr" ] && Log "Setting up Fajr Time..." && bash -c "sleep $DIFF && $COMMAND_MB_START && (pkill vlc;cvlc $(find $FOLDER/mp3/fajr_*.mp3 -type f | shut -n 1) vlc://quit) && $COMMAND_MB_END" 2>&1 &
	[ $DIFF -gt 0 ] && [ "$ADHAN" != "Fajr" ] && Log "Setting up Adhan Time... for $ADHAN" && bash -c "sleep $DIFF && $COMMAND_MB_START && (pkill vlc;cvlc $(find $FOLDER/mp3/adhan_*.mp3 -type f | shuf -n 1) vlc://quit) && $COMMAND_MB_END" 2>&1 &
}

DecideAdhan Fajr
DecideAdhan Dhuhr
DecideAdhan Asr
DecideAdhan Maghrib
DecideAdhan Isha

exit 0
