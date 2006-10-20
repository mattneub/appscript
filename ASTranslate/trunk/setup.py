from distutils.core import setup
import py2app

plist = dict(
    CFBundleDocumentTypes = [
        dict(
            CFBundleTypeExtensions=[],
            CFBundleTypeName="Text File",
            CFBundleTypeRole="Editor",
            NSDocumentClass="ASTranslateDocument",
        ),
    ]
)


setup(
    app=["ASTranslate.py"],
    version='0.2.0',
    data_files=["MainMenu.nib", "ASTranslateDocument.nib"],
    options=dict(py2app=dict(plist=plist)),
)
