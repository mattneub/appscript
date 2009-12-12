#!/bin/bash

for f in `ls | grep '^test_'`;
do
	echo $f
	/usr/bin/env python3 $f
	echo
	echo
done

