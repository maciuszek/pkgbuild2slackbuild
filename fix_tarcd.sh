#!/bin/sh

# Incase an error in the translation occurs
echo "Working on Package $1:"

cd Packages-for-Slackware/$1/

tar_name=$(basename $(cat source.lst | head -1))
extract_name=$(basename $(cat source.lst | head -1 | sed \
's/.orig//g' | sed 's/.tar.gz//g' | sed 's/.tar.xz//g' | sed \
's/.tar.bz2//g' | sed 's/.tar.Z//g' | sed 's/_\([0-9]\)/-\1/'))

cp $1.SlackBuild $1.SlackBuild.bak

touch $1.SlackBuild.1 $1.SlackBuild.2 $1.SlackBuild.3
cat $1.SlackBuild | sed s,'rm -rf $PRGNAM-$VERSION',"rm -rf $extract_name",g > $1.SlackBuild.1
cat $1.SlackBuild.1 | sed s,'tar xvf $CWD/$PRGNAM-$VERSION.tar.gz',"tar xvf \$CWD/$tar_name",g > $1.SlackBuild.2
cat $1.SlackBuild.2 | sed s,'cd $PRGNAM-$VERSION',"cd $extract_name",g > $1.SlackBuild.3

mv $1.SlackBuild.3 $1.SlackBuild
rm $1.SlackBuild.[1-3]

cd -

exit 1
