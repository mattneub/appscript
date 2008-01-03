try:
	from setuptools import setup, Extension
except ImportError:
		print "Note: couldn't import setuptools so using distutils instead."
		from distutils.core import setup, Extension


setup(
		name = "appscript",
		version = "0.18.1",
		description = "appscript and related modules",
		author = "HAS",
		author_email='',
		url='http://appscript.sourceforge.net',
		license='MIT',
		platforms=['Mac OS X'],
		ext_modules = [
			Extension('CarbonX._AE',
				sources=['Modules/CarbonX/_AEmodule.c'],
				extra_link_args=['-framework', 'Carbon'],
			),
			Extension('CarbonX._OSA',
				sources=['Modules/CarbonX/_OSAmodule.c'],
				extra_link_args=['-framework', 'Carbon'],
			),
			Extension('aem.send.PSN',
				sources=['Modules/aem/PSN.c'],
				extra_link_args=['-framework', 'Carbon'],
			),
			Extension('osaterminology.getterminology.OSATerminology',
				sources=['Modules/osaterminology/OSATerminology.c'],
				extra_compile_args=['-DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_2'],
				extra_link_args=['-framework', 'Carbon'],
			),
		],
		packages = [
			'CarbonX',
			'aem',
			'aem/send',
			'aem/types',
			'aem/types/basictypes', 
			'aem/types/objectspecifiers',
			'aemreceive',
			'appscript',
			'appscript/tools',
			'osaterminology',
			'osaterminology/dom',
			'osaterminology/getterminology',
			'osaterminology/renderers',
			'osaterminology/sax',
		],
		py_modules=[
			'mactypes',
			'osascript',
			'osax',
		],
		extra_path = "aeosa",
		package_dir = { '': 'Lib' }
)
