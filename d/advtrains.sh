#!/bin/bash
tmp=$(mktemp -d)
dir=$PWD
cd $tmp
if 7z x -r -o./ $DOWNLOAD/advtrains.zip ;then
	cp -rvf ./*/*/ $dir
	cd $dir
	rm -rvf $tmp
else
	echo "【错误】解压或下载https://github.com/orwell96/advtrains/raw/master/advtrains.zip失败" 1>&2
	exit 1
fi
