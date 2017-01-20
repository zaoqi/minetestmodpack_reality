#!/bin/bash
dir=$PWD

#mod
tmp=$(mktemp -d)
cd $tmp
for zip in $SRC/nuke2.1.zip $DOWNLOAD/file.php\?id\=6235 $DOWNLOAD/file.php\?id\=8612 ;do
	if 7z x -r -o./ "$zip" || unzip "$zip" ;then
		echo "解压$zip成功"
	else
		echo "【错误】解压$zip失败" 1>&2
		exit 1
	fi
done
mv -vf ./*/ $dir
cd $dir
rm -rvf $tmp

#modpack
tmp=$(mktemp -d)
cd $tmp
for zip in $DOWNLOAD/advtrains.zip ;do
	if 7z x -r -o./ "$zip" || unzip "$zip" ;then
		echo "解压$zip成功"
	else
		echo "【错误】解压$zip失败" 1>&2
		exit 1
	fi
done
mv -vf ./*/*/ $dir
cd $dir
rm -rvf $tmp
