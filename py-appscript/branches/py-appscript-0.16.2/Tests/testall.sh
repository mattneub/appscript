#!/bin/bash

for f in `ls | grep test_`;
do
	echo $f
	/usr/local/bin/python $f
	echo
	echo
done

