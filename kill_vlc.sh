#!/bin/bash


kill -9 $(ps -aux | grep vlc | grep -v grep | awk '{ print $2 }')
