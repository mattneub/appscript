"""
Requirements:

- appscript 0.16.1+ <http://appscript.sourceforge.net>

- pyobjc <http://pyobjc.sourceforge.net>

- py2app <http://undefined.org/python/>

--

To build, cd to this directory and run:

	python setup.py py2app

"""


from distutils.core import setup
import py2app

plist = dict(
    CFBundleDocumentTypes = [
        dict(
            CFBundleTypeExtensions=[],
            CFBundleTypeName="Text File",
            CFBundleTypeRole="Editor",
            NSDocumentClass="ASTranslateDocument",
            CFBundleIdentifier="net.sourceforge.appscript.astranslate"
        ),
    ]
)


setup(
    app=["ASTranslate.py"],
    version='0.3.1',
    data_files=["MainMenu.nib", "ASTranslateDocument.nib", "rubyrenderer.rb"],
    options=dict(py2app=dict(plist=plist)),
)
