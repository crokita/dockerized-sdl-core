#!/bin/bash

# This script replaces the IP address in smartDeviceLink.ini with the machine's IP address and then runs SmartDeviceLink Core.
# The IPis required to be replaced for the websocket connection with the HMI to function.
DOCKER_IP="$(hostname -i)"
echo "Changing smartDeviceLink.ini HMI ServerAddress to ${DOCKER_IP}"

# Replace the IP address in smartDeviceLink.ini with the machines IP address
perl -pi -e 's/127.0.0.1/'$DOCKER_IP'/g' /usr/sdl/src/appMain/smartDeviceLink.ini

echo "Posting ${HOST_IP} to etcd"
#Post to the etcd database that this container exists
curl -L -X PUT http://192.168.1.130:4001/v2/keys/servers/core -d value="${HOST_IP}"

#Start SDL Core
#cmake -DTIME_TESTER=OFF /usr/sdl
/usr/sdl/src/appMain/smartDeviceLinkCore