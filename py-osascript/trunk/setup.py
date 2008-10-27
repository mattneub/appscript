try:
	from setuptools import setup, Extension
except ImportError:
	print "Note: couldn't import setuptools so using distutils instead."
	from distutils.core import setup, Extension


setup(
		name = "osascript",
		version = "0.6.0",
		description = "Load and run OSA scripts from Python.",
		author = "HAS",
		author_email='',
		url='http://appscript.sourceforge.net',
		license='MIT',
		platforms=['Mac OS X'],
		ext_modules = [
			Extension('osascript.osa',
				sources=['ext/osa.c'],
				extra_compile_args=['-DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_2'],
				extra_link_args=[
						'-framework', 'CoreFoundation', 
						'-framework', 'ApplicationServices',
						'-framework', 'Carbon'],
			),
		],
		packages = [
			'osascript',
		],
		extra_path = "aeosa",
		package_dir = { '': 'lib' }
)
