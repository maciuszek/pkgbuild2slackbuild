#!/bin/sh

declare -a temp=($(ls Packages-for-Arch/$1 | grep -v PKGBUILD | grep -v compare_versions.sh))

for archfile in ${temp[*]}
do 
	cp -v Packages-for-Arch/$1/$archfile Packages-for-Slackware/$1/
done

exit 1
