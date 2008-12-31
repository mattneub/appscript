try:
	from setuptools import setup, Extension
except ImportError:
	print("Note: couldn't import setuptools so using distutils instead.")
	from distutils.core import setup, Extension

import os, sys

if sys.version_info >= (3,0):
	root_dir = 'appscript_3x'
	packages = []
else:
	root_dir = 'appscript_2x'
	packages =['CarbonX']


setup(
		name = "appscript",
		version = "0.19.1",
		description = "Control scriptable Mac OS X applications and scripting additions from Python.",
		author = "HAS",
		author_email='',
		url='http://appscript.sourceforge.net',
		license='MIT',
		platforms=['Mac OS X'],
		ext_modules = [
			Extension('aem.ae',
				sources=[os.path.join(root_dir, 'ext/ae.c')],
				extra_compile_args=['-DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_3'],
				extra_link_args=[
						'-framework', 'CoreFoundation', 
						'-framework', 'ApplicationServices',
						'-framework', 'Carbon'],
			),
		],
		packages = packages + [
			'aem',
			'appscript',
		],
		py_modules=[
			'mactypes',
			'osax',
		],
		extra_path = "aeosa",
		package_dir = {'': os.path.join(root_dir, 'lib')}
)
