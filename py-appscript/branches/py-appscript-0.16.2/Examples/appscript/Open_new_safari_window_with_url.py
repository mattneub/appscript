#!/usr/bin/env python

from appscript import *

app('Safari').documents.end.make(
		new=k.document, 
		with_properties={k.URL: 'file://localhost/Users/has/foo.html'})