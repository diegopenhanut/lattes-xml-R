#!/usr/bin/env sh

for i in $(find ./data -name "*.zip")
do 
	base=$(basename $i .zip)
	newfile=./data/$base.gz
	unzip -p $base | gzip -c > $newfile
	echo "done converting $base"
done
