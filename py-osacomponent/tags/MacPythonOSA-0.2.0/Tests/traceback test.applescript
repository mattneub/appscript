# Demonstrates error reporting system.

def x():
	raise TypeError, 'Oops'


def y():
	return x()


def z():
	return y()


def run():
	return z()