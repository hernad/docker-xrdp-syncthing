#!/bin/bash

SYNCTHING_USER=syncthing

# if this if the first run, generate a useful config
if [ ! -f /home/$SYNCTHING_USER/syncthing/config/config.xml ]; then
  echo "generating config"
  /home/$SYNCTHING_USER/bin/syncthing --generate="/home/$SYNCTHING_USER/syncthing/config"
  # don't take the whole volume with the default so that we can add additional folders
  sed -e "s/id=\"default\" path=\"\/root\/Sync\"/id=\"default\" path=\"\/home\/$SYNCTHING_USER\/syncthing\/data\/default\"/" -i /home/$SYNCTHING_USER/syncthing/config/config.xml
  # ensure we can see the web ui outside of the docker container
	sed -e "s/<address>127.0.0.1:8384/<address>0.0.0.0:8384/" -i /home/$SYNCTHING_USER/syncthing/config/config.xml
fi

