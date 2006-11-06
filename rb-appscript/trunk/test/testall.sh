#!/bin/bash

for f in `ls | grep test_`;
do
	/usr/local/bin/ruby $f
	echo
	echo
done

