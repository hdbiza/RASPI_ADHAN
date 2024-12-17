#!/bin/bash

set -ue

MEGABOOM="EC:81:93:2A:08:B8"
BLUETOOTH_MAC="B8:27:EB:14:BB:36"
HANDLE="0x0003"
VALUE="${BLUETOOTH_MAC//:/}01"

if [[ "$(bluetoothctl info $MEGABOOM | grep Connected |cut -d ' ' -f 2)" != yes ]]; then
	echo "Starting  MB"
	gatttool -b $MEGABOOM --char-write-req --handle=$HANDLE --value=$VALUE
	sleep 10
	echo "Connexion au MB"
	bluetoothctl connect $MEGABOOM
fi
