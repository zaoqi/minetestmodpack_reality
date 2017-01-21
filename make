#!/bin/bash
error() {
	wait
	echo [ERROR] 1>&2
	exit 1
}
moddir=$(mktemp -d)
packdir=$(mktemp -d)
DOWNLOAD=$(mktemp -d)
dir=$PWD
SRC=$PWD/src
zipMods=$SRC/nuke2.1.zip $DOWNLOAD/file.php\?id\=6235 $DOWNLOAD/file.php\?id\=8612 $DOWNLOAD/file.php\?id\=87
zipMobpacks=$DOWNLOAD/advtrains.zip
unZip() {
	7z x -r -o./ "$1" || unzip "$1" || return 1
}

{
	rm -rfv build/
	mkdir $dir/build
	touch $dir/build/modpack.txt
}&
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

cd $moddir
for zip in $zipMods ;do
	unZip "$zip" || {
		echo "【错误】解压$zip失败" 1>&2
		error
	}
done
cd $packdir
for zip in $zipMobpacks ;do
	unZip "$zip" || {
		echo "【错误】解压$zip失败" 1>&2
		error
	}
done

cd $dir/build
for license in $packdir/*/LICENSE* $packdir/*/license* $packdir/*/README* $packdir/*/readme* $packdir/*/*.txt ;do
	cp $license $(dirname $license)/*/ &
done

wait
mv -vf $moddir/*/ $packdir/*/*/ ./ 2>/dev/null
rm -rvf $moddir/ $packdir/ $(find -name .git)

cd $dir/build
for d in $(ls $dir/d/) ;do
	bash $dir/d/$d || error &
done

wait
rm -rvf $DOWNLOAD/
