#!/bin/bash
tmp=$(mktemp -d)
dir=$PWD
cd $tmp
if 7z x -r -o./ $SRC/nuke2.1.zip ;then
	cp -rvf ./*/ $dir
	cd $dir
	rm -rvf $tmp
else
	echo "【错误】解压https://dl.dropboxusercontent.com/u/30267315/Minetest/nuke2.1.zip失败" 1>&2
	exit 1
fi
