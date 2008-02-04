try:
	from setuptools import setup, Extension
except ImportError:
		print "Note: couldn't import setuptools so using distutils instead."
		from distutils.core import setup, Extension


setup(
		name = "aeserver",
		version = "0.2.0",
		description = "Apple event handling framework",
		author = "HAS",
		author_email='',
		url='http://appscript.sourceforge.net',
		license='MIT',
		platforms=['Mac OS X'],
		packages = [
			'aemreceive',
		],
		extra_path = "aeosa",
		package_dir = { '': 'lib' }
)
