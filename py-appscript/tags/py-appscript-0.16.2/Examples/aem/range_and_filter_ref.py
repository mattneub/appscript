#!/usr/bin/env pythonw

from aem import *

print app.elements('docu').byrange(
		con.elements('cpar').byindex(2), 
		con.elements('cpar').byindex(9)
		).byfilter(
				its.property('size').ne(0)
		).byrange(
			con.elements('cpar').byindex(3), 
			con.elements('cpar').byindex(5)
			).byfilter(
					its.property('size').gt(2)
			)
			