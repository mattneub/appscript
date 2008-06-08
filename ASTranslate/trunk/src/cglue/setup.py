from distutils.core import setup, Extension

setup(
		name = "astranslate_cglue",
		version = "0.1.0",
		description = "",
		author = "HAS",
		author_email='',
		url='http://appscript.sourceforge.net',
		license='MIT',
		platforms=['Mac OS X'],
		ext_modules = [
			Extension('astranslate_cglue',
				sources=['astranslate_cglue.c'],
				extra_compile_args=['-DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_3'],
				extra_link_args=['-framework', 'Carbon'],
			),
		]
)
