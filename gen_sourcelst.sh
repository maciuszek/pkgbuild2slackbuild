#!/bin/sh

let end_varln=$(cat Packages-for-Arch/$1/PKGBUILD | grep -n 'prepare() {\|build() {\|package() {' | head -1 | cut -d: -f1)-1
(head "-$end_varln" Packages-for-Arch/$1/PKGBUILD && echo 'echo ${source[*]}') | bash | sed 's/ /\n/g' > Packages-for-Slackware/$1/source.lst

exit 1
