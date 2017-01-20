#!/bin/bash
error() {
	wait
	echo [ERROR] 1>&2
	exit 1
}
moddir=$(mktemp -d)
packdir=$(mktemp -d)
export DOWNLOAD=$(mktemp -d)
dir=$PWD
export SRC=$PWD/src

rm -rfv build/ &
cd $moddir
for mod in $(cat $dir/mods.txt) ;do
	git clone "$mod" || error &
done
cd $packdir
for pack in $(cat $dir/modpacks.txt) ;do
	git clone "$pack" || error &
done
cd $DOWNLOAD
for file in $(cat $dir/download.txt) ;do
	wget "$file" || error &
done
cd $dir

wait
cd $dir
mkdir build
cd build
touch modpack.txt
mv -vf $moddir/*/ $packdir/*/*/ ./ 2>/dev/null
rm -rvf $moddir/ $packdir/ $(find -name .git) &

cd $dir/build
for d in $(ls $dir/d/) ;do
	bash $dir/d/$d || error &
done

wait
rm -rvf $DOWNLOAD/
