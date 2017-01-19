#!/bin/bash
#mod
tmp=$(mktemp -d)
dir=$PWD
cd $tmp
for zip in $SRC/nuke2.1.zip $DOWNLOAD/file.php\?id\=6235 $DOWNLOAD/file.php\?id\=8612 ;do
	mv $zip un.zip
	if 7z x -r -o./ ./un.zip || unzip ./un.zip ;then
		echo "解压$zip成功"
	else
		echo "【错误】解压$zip失败" 1>&2
		exit 1
	fi
done
cp -rvf ./*/ $dir
cd $dir
rm -rvf $tmp

#modpack
tmp=$(mktemp -d)
cd $tmp
if 7z x -r -o./ $DOWNLOAD/advtrains.zip || unzip $DOWNLOAD/advtrains.zip ;then
	cp -rvf ./*/*/ $dir
else
	echo "【错误】解压或下载https://github.com/orwell96/advtrains/raw/master/advtrains.zip失败" 1>&2
	exit 1
fi
cd $dir
rm -rvf $tmp
