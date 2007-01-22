try:
	from setuptools import setup, Extension
except ImportError:
		print "Note: couldn't import setuptools so using distutils instead. bdist_mpkg option is also unavailable."
		from distutils.core import setup, Extension
		kargs = {}
else:
	try:
		from bdist_mpkg.cmd_bdist_mpkg import bdist_mpkg as _bdist_mpkg
		from py2app.util import skipjunk
	except ImportError:
		print "Note: couldn't import bdist_mpkg/py2app so bdist_mpkg option option is unavailable."
		kargs = {}
	else:
	
		CUSTOM_SCHEMES= dict(
				examples=(
					u'(Optional) appscript Example Code',
					'/Developer/Python/appscript/Examples',
					'Examples',
				),
				docs=(
					u'(Optional) appscript documentation',
					'/Developer/Python/appscript/Documentation',
					'Documentation'
				),
			)
		
		
		class appscript_bdist_mpkg(_bdist_mpkg):
			def initialize_options(self):
				_bdist_mpkg.initialize_options(self)
				#self.readme = 'path/to/readme'
				for scheme, (description, prefix, source) in CUSTOM_SCHEMES.items():
					self.scheme_descriptions[scheme] = description
					self.scheme_map[scheme] = prefix
					self.scheme_copy[scheme] = source
				#self.scheme_command['doc'] = 'build_html'
		
			def copy_tree(self, *args, **kw):
				if kw.get('condition') is None:
					kw['condition'] = skipjunk
				return _bdist_mpkg.copy_tree(self, *args, **kw)
		
		kargs = dict(
				cmdclass={'bdist_mpkg': appscript_bdist_mpkg},
				zip_safe=False)
		

setup(
		name = "appscript",
		version = "0.17.1",
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
		package_dir = { '': 'Lib' },
		**kargs
)
