#!/usr/bin/env bash

# A simple script to update Zoom on Linux

# fetch the latest version from the website
latestVersion=$(curl --silent "https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0061222" | sed "s/table-row/table-row\n/g" | grep -A1 -m1 -P "\>Linux\<.*table-row" | head -2 | tail -n1 | sed 's/<\/td><td>/\n/g' | head -3 | tail -n1 | sed -E "s/(.+) \(([0-9]+)\)/\1.\2/")

if [ -z "$latestVersion" ]; then
	echo "Failed to retrieve latest version of Zoom."
	echo "Try again later."
	exit 1
fi

# local version
localVersion=$(dpkg -s zoom | grep Version | cut -d " " -f 2)

echo "latest Zoom $latestVersion"
echo " local Zoom $localVersion"

# update zoom if versions do not match
if [ "$localVersion" = "$latestVersion" ]; then
	echo -e "\nYou are already using the latest version of Zoom."
elif [ "$latestVersion" = "--" ]; then
	echo -e "\nCould not retrieve the latest Zoom version."
else
	echo -e "\nZoom v${latestVersion} is available. Installing update."
	wget -O /tmp/zoom.deb https://zoom.us/client/latest/zoom_amd64.deb || (echo "Cannot fetch the latest zoom, check your internet connection." && exit 1)
	echo "If you are currently using Zoom, you'll need to restart it after this update is complete."
	sudo dpkg -i /tmp/zoom.deb || (echo "Install failed, uninstalling the broken package..." && sudo apt-get purge zoom)
fi
