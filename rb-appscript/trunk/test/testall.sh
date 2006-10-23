#!/bin/bash

for f in `ls | grep test_`;
do
	echo $f
	/usr/local/bin/ruby $f
	echo
	echo
done

