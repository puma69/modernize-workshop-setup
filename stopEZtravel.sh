#!/bin/bash

if ! [ $(id -u) = 0 ]; then
   echo "ERROR: script must be run as root or with sudo"
   exit 1
fi

echo "*** Stopping EasyTravel ***"

if [ "$(ps aux | grep -i /home/workshop/easytravel | wc -l)" != "1" ]; then
  echo "Stopping easytravel processes"
  kill `ps aux | grep -i /home/workshop/easytravel | awk '{print $2}'`
else
  echo "No easytravel processes to stop"
fi

if [ "$(ps aux | grep -i com.dynatrace.easytravel | wc -l)" != "1" ]; then
  echo "Stopping easytravel Java processes"
  kill `ps aux | grep -i com.dynatrace.easytravel | awk '{print $2}'`
else
  echo "No easytravel Java processes to stop"
fi

CONTAINER=$(sudo docker ps -f name=reverseproxy -q)
if [ "$CONTAINER" != "" ]; then
  echo "removing reverseproxy Docker container"
  docker stop $CONTAINER
  docker rm $CONTAINER
else
  echo "No containers to stop"
fi

echo "*** Stopping EasyTravel Done. ***"