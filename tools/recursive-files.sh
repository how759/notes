#!/bin/bash


allFiles() {
for file in $1/*
do
if [ -d $file ]; then
# allFiles $file
:
else
renameFiles $file 
fi
done
}

renameFiles() {
	filename=${1##*/}
	DIR=${1%/*}
	new_filename=$( echo $filename |tr -cd "[0-9]" )
	if [[ $filename =~ ^out[0-9]+.log.match ]]; then
		echo $filename
		echo TEST$new_filename.out.match
		mv $DIR/$filename $DIR/TEST$new_filename.out.match
	fi
}

testdir=/home/ssg-test/Repos/quicklake-js/src/pmemlog-addon/test/log_pool
allFiles $testdir 
