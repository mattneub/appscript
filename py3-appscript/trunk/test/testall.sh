#!/bin/bash

for f in `ls | grep '^test_'`;
do
	echo $f
	/usr/local/bin/python3.0 $f
	echo
	echo
done

