#!/bin/bash

SYNCTHING_USER=dockerx

# if this if the first run, generate a useful config
[ -f /home/$SYNCTHING_USER/syncthing/config/config.xml ] && exit 0


CONFIG=/home/$SYNCTHING_USER/syncthing/config/config.xml

echo "generating config"
/home/$SYNCTHING_USER/bin/syncthing --generate="/home/$SYNCTHING_USER/syncthing/config"
# don't take the whole volume with the default so that we can add additional folders
sed -e "s/id=\"default\" path=\"\/root\/Sync\/\"/id=\"default\" path=\"\/home\/$SYNCTHING_USER\/syncthing\/data\/default\/\"/" -i $CONFIG

# ensure we can see the web ui outside of the docker container
sed -e "s/<address>127.0.0.1:8384/<address>0.0.0.0:8080/" -i $CONFIG


chown $SYNCTHING_USER.users -R /home/$SYNCTHING_USER

