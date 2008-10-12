#!/bin/bash

for f in `ls | grep '^test_'`;
do
	echo $f
	/usr/bin/python $f
	echo
	echo
done

