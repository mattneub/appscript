try:
	from setuptools import setup, Extension
except ImportError:
	print "Note: couldn't import setuptools so using distutils instead."
	from distutils.core import setup, Extension


setup(
		name = "aeserver",
		version = "0.3.0",
		description = "Modules for adding Apple event handling support to Python-based Mac OS X applications.",
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
