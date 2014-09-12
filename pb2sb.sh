#!/bin/sh

# Incase an error in the translation occurs
echo "Working on Package $1:"

name=$(cat Packages-for-Arch/$1/PKGBUILD | grep pkgname | head -1 | cut -d= -f2)
ver=$((cat Packages-for-Arch/$1/PKGBUILD && echo 'echo $pkgver') | bash)

mkdir -p Packages-for-Slackware/$1

sed "s/appname/$name/g" < templates/generic.SlackBuild > Packages-for-Slackware/$1/$1.SlackBuild.part.1
sed "s/vernum/$ver/g" < Packages-for-Slackware/$1/$1.SlackBuild.part.1 > Packages-for-Slackware/$1/$1.SlackBuild.part.2

touch bri.1
let write_bri=0

cat Packages-for-Arch/$1/PKGBUILD | while read pb
do
     if [ "$pb" == '}' ]
     then
        let write_bri=0
     fi

     if [ "$write_bri" -eq 1 ]
     then
        echo $pb >> bri.1
     fi

     if [ "$pb" == 'prepare() {' -o "$pb" == 'build() {' -o "$pb" == 'package() {' ]
     then
	let write_bri=1
     fi
done

touch bri.2 bri.3 bri.4 bri 
cat bri.1 | sed 's,cd "${srcdir}.*",,g' > bri.2 || echo 'Warning: bri.2 did not pass'
cat bri.2 | sed 's,${srcdir},$CWD,g' > bri.3 || echo 'Warning: bri.3 did not pass'
cat bri.3 | sed 's,${pkgdir},$PKG,g' > bri.4 || echo 'Warning: bri.4 did not pass'
cat bri.4 | sed s,'${pkgname}',"$name",g > bri.5 || echo 'Warning: bri.5 did not pass'
cat bri.5 | sed 's,msg ".*",,g' > bri || echo 'Warning: bri did not pass'

cat Packages-for-Slackware/$1/$1.SlackBuild.part.2 | while read sb 
do 
    echo $sb >> Packages-for-Slackware/$1/$1.SlackBuild

    if [ "$sb" == '# Start BRI' ]
    then 
        cat bri >> Packages-for-Slackware/$1/$1.SlackBuild 
    fi
done

rm bri.[1-5] bri

rm Packages-for-Slackware/$1/$1.SlackBuild.part.1
rm Packages-for-Slackware/$1/$1.SlackBuild.part.2

exit 1
