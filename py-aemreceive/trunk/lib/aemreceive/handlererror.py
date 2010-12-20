"""handlererror -- Used to pass known errors back to client."""

from aem import kae


class EventHandlerError(Exception):
	"""Event-handling callbacks should raise an EventHandlerError exception to send an error message back to client."""
	def __init__(self, number, message=None, object=None, coercion=None):
		self.number = number
		self.message = message
		self.object = object
		self.coercion = coercion
		Exception.__init__(self, number, message, object, coercion)
	
	def get(self): # used internally by aemreceive
		result = {kae.keyErrorNumber: self.number}
		for key, val in [
				(kae.keyErrorString, self.message), 
				(kae.kOSAErrorOffendingObject, self.object), 
				(kae.kOSAErrorExpectedType, self.coercion)]:
			if val is not None:
				result[key] = val
		return result
	
	def __str__(self):
		return '%s (%i)' % (self.message, self.number)