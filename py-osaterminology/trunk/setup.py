try:
	from setuptools import setup, Extension
	args = {'install_requires': ['appscript >= 0.22.0']}
except ImportError:
	print "Note: couldn't import setuptools so using distutils instead."
	from distutils.core import setup, Extension
	args = {}


setup(
		name = "osaterminology",
		version = "0.14.5",
		description = "Parse and render aete/sdef resources.",
		url='http://appscript.sourceforge.net',
		license='Public Domain',
		platforms=['Mac OS X'],
		packages = [
			'osaterminology',
			'osaterminology/defaultterminology',
			'osaterminology/dom',
			'osaterminology/makeglue',
			'osaterminology/makeidentifier',
			'osaterminology/renderers',
			'osaterminology/sax',
			'osaterminology/tables',
		],
		extra_path = "aeosa",
		package_dir = { '': 'lib' },
		**args
)
