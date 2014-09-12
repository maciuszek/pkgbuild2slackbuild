#!/bin/sh

cd Packages-for-Slackware/$1/
cat source.lst | grep '://' | while read url
do
   wget -a ../../logs/source_res.log "$url" || echo "Warning: issue resolving dep in $1"
done
cd -

exit 1
