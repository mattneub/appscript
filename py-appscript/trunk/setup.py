try:
	from setuptools import setup, Extension
except ImportError:
	print "Note: couldn't import setuptools so using distutils instead."
	from distutils.core import setup, Extension


setup(
		name = "appscript",
		version = "0.19.0",
		description = "appscript and related modules",
		author = "HAS",
		author_email='',
		url='http://appscript.sourceforge.net',
		license='MIT',
		platforms=['Mac OS X'],
		ext_modules = [
			Extension('aem.ae',
				sources=['ext/ae.c'],
				extra_compile_args=['-DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_2'],
				extra_link_args=[
						'-framework', 'CoreFoundation', 
						'-framework', 'ApplicationServices',
						'-framework', 'Carbon'],
			),
		],
		packages = [
			'CarbonX',
			'aem',
			'appscript',
		],
		py_modules=[
			'mactypes',
			'osax',
		],
		extra_path = "aeosa",
		package_dir = { '': 'lib' }
)
