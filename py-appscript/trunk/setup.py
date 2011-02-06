try:
	from setuptools import setup, Extension
except ImportError:
	print("Note: couldn't import setuptools so using distutils instead.")
	from distutils.core import setup, Extension

import os, sys

if sys.version_info >= (3,0):
	root_dir = 'appscript_3x'
else:
	root_dir = 'appscript_2x'


setup(
		name = "appscript",
		version = "1.0.0",
		description = "Control AppleScriptable applications from Python.",
		url='http://appscript.sourceforge.net',
		license='Public Domain',
		platforms=['Mac OS X'],
		ext_modules = [
			Extension('aem.ae',
				sources=[os.path.join(root_dir, 'ext/ae.c')],
				extra_compile_args=['-DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_4'],
				extra_link_args=[
						'-framework', 'CoreFoundation', 
						'-framework', 'ApplicationServices',
						'-framework', 'Carbon'],
			),
		],
		packages = [
			'aem',
			'appscript',
		],
		py_modules=[
			'mactypes',
			'osax',
		],
		extra_path = "aeosa",
		package_dir = {'': os.path.join(root_dir, 'lib')},
		classifiers = [
			'License :: Public Domain',
			'Development Status :: 5 - Production/Stable',
			'Operating System :: MacOS :: MacOS X',
			'Programming Language :: Python :: 2',
			'Programming Language :: Python :: 3',
		],

)
