#!/bin/bash
error() {
	wait
	echo [ERROR] 1>&2
	exit 1
}
readList() {
	cat "$*" | awk '{print $0}'
}
src=$PWD/src
insrc() {
	for f in $@ ;do
		echo -n "$src/$(basename $f) "
	done
	echo
}
moddir=$(mktemp -d)
packdir=$(mktemp -d)
download=$(mktemp -d)
dir=$PWD
zipMods="$(insrc $(readList $dir/modsSrc.txt))"
zipModpacks="$(insrc $(readList $dir/modpacksSrc.txt))"
unZip() {
	7z x -r -o./ "$1" || unzip "$1" || return 1
}

{
	rm -rfv build/
	mkdir $dir/build
	touch $dir/build/modpack.txt
}&
cd $moddir
for mod in $(readList $dir/mods.txt) ;do
	git clone "$mod" || error &
done
cd $packdir
for pack in $(readList $dir/modpacks.txt) ;do
	git clone "$pack" || error &
done
cd $download
for file in $(readList $dir/modsWget.txt) ;do
	zipMods="$zipMods $download/$(basename $file)"
	wget "$file" || error &
done
for file in $(readList $dir/modpacksWget.txt) ;do
	zipModpacks="$zipModpacks $download/$(basename $file)"
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
for license in $packdir/*/LICENSE* $packdir/*/license* $packdir/*/README* $packdir/*/readme* ;do
	cp $license $(dirname $license)/*/ &
done

wait
mv -vf $moddir/*/ $packdir/*/*/ ./ 2>/dev/null
rm -rvf $moddir/ $packdir/ $download/ $(find -name .git)

cd $dir/build
for d in $(ls $dir/d/) ;do
	bash $dir/d/$d || error &
done

wait
