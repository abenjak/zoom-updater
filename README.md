# zoom-updater
**A simple script to update Zoom on Linux**

Zoom is not available in Linux repositories, and therefore not possible to update with `apt`.
Zoom has an auto-update feature triggered upon GUI launch, but it's inconvenient (say you are in a hurry to connect to a Zoom call only to be greeted with the update message).
This script attempts to update Zoom programmatically (it can be used on startup).

There are two strategies I can think of:
1) Download the latest `zoom_amd64.deb` and extract the version from it (works fine, but will download a ~167 MB file every time)
2) Fetch the version from the [release notes](https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0061222) (a lighter solution, but parsing that website is not straightforward)

Solution 2 is implemented here.

If we ever need to use solution 1, this is how it could work:
```
# solution 1)
mkdir -p /tmp/zoom
rm /tmp/zoom/*
cd /tmp/zoom

fetch the latest zoom
wget https://zoom.us/client/latest/zoom_amd64.deb || (echo "Cannot fetch the latest zoom, check your internet connection." && exit 1)

extract and look for version
ar x zoom_amd64.deb
tar xf control.tar.xz
latestVersion=$(grep Version control | cut -f2 -d" ")
```
