#!/bin/bash
moddir=$(mktemp -d)
packdir=$(mktemp -d)
export DOWNLOAD=$(mktemp -d)
dir=$PWD
export SRC=$PWD/src

cd $moddir
for mod in $(cat $dir/mods.txt) ;do
	git clone "$mod"&
done
cd $packdir
for pack in $(cat $dir/modpacks.txt) ;do
	git clone "$pack"&
done
cd $dir
for file in $(cat $dir/download.txt) ;do
	wget "$file"&
done

wait

cd $dir
rm -rfv build/
mkdir -p build
cd build
touch modpack.txt
cp -rvf $moddir/*/ ./ 2>/dev/null
cp -rvf $packdir/*/*/ ./ 2>/dev/null
rm -rvf $moddir/ $packdir/ $DOWNLOAD/ $(find -name .git)

cd $dir/build
for d in $(ls $dir/d/) ;do
	bash $dir/d/$d || exit
done
