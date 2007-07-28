"""handlererror -- Used to pass known errors back to client.

(C) 2005 HAS
"""

from CarbonX import kAE

kOSAErrorOffendingObject = 'erob'
kOSAErrorExpectedType = 'errt'


class EventHandlerError(Exception):
	"""Event-handling callbacks should raise an EventHandlerError exception to send an error message back to client."""
	def __init__(self, number, message=None, object=None, coercion=None):
		self.number = number
		self.message = message
		self.object = object
		self.coercion = coercion
		Exception.__init__(self, number, message, object, coercion)
	
	def get(self): # used internally by aemreceive
		result = {kAE.keyErrorNumber: self.number}
		for key, val in [
				(kAE.keyErrorString, self.message), 
				(kOSAErrorOffendingObject, self.object), 
				(kOSAErrorExpectedType, self.coercion)]:
			if val is not None:
				result[key] = val
		return result
	
	def __str__(self):
		return '%s (%i)' % (self.message, self.number)