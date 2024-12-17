#!/bin/bash

set -ue

MEGABOOM="EC:81:93:2A:08:B8"
BLUETOOTH_MAC="B8:27:EB:14:BB:36"
HANDLE="0x0003"
VALUE="${BLUETOOTH_MAC//:/}02"

if [[ "$(bluetoothctl info $MEGABOOM | grep Connected |cut -d ' ' -f 2)" != no ]]; then
	echo "Deconnexion du MB"
	bluetoothctl disconnect $MEGABOOM
	sleep 10
fi

echo "Ending  MB"
gatttool -b $MEGABOOM --char-write-req --handle=$HANDLE --value=$VALUE
