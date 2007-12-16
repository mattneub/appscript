#!/bin/bash

for f in `ls | grep '^test_'`;
do
	echo $f
	/usr/bin/ruby -w $f
	echo
	echo
done

