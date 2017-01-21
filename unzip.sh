#!/bin/bash
unZip() {
	7z x -r -o./ "$1" || unzip "$1" || return 1
}
dir=$PWD

#mod
tmp=$(mktemp -d)
cd $tmp
for zip in $SRC/nuke2.1.zip $DOWNLOAD/file.php\?id\=6235 $DOWNLOAD/file.php\?id\=8612 $DOWNLOAD/file.php\?id\=87 ;do
	unZip "$zip" || {
		echo "【错误】解压$zip失败" 1>&2
		exit 1
	}
done
mv -vf ./*/ $dir
cd $dir
rm -rvf $tmp

#modpack
tmp=$(mktemp -d)
cd $tmp
for zip in $DOWNLOAD/advtrains.zip ;do
	unZip "$zip" || {
		echo "【错误】解压$zip失败" 1>&2
		exit 1
	}
done
mv -vf ./*/*/ $dir
cd $dir
rm -rvf $tmp
