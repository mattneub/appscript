def _site_packages():
    import site, sys, os
    paths = []
    prefixes = [sys.prefix]
    if sys.exec_prefix != sys.prefix:
        prefixes.append(sys.exec_prefix)
    for prefix in prefixes:
        paths.append(os.path.join(prefix, 'lib', 'python' + sys.version[:3],
            'site-packages'))
    if os.path.join('.framework', '') in os.path.join(sys.prefix, ''):
        home = os.environ.get('HOME')
        if home:
            paths.append(os.path.join(home, 'Library', 'Python',
                sys.version[:3], 'site-packages'))
    for path in paths:
        site.addsitedir(path)
_site_packages()


def _chdir_resource():
    import os
    os.chdir(os.environ['RESOURCEPATH'])
_chdir_resource()


def _path_inject(paths):
    import sys
    sys.path[:0] = paths


_path_inject(['/Users/has/appscript/AppscriptHelpAgent/src'])


def _run(*scripts):
    global __file__
    import os, sys, site
    import Carbon.File
    sys.frozen = 'macosx_app'
    site.addsitedir(os.environ['RESOURCEPATH'])
    for (script, path) in scripts:
        alias = Carbon.File.Alias(rawdata=script)
        target, wasChanged = alias.ResolveAlias(None)
        if not os.path.exists(path):
            path = target.as_pathname()
        sys.path.append(os.path.dirname(path))
        sys.argv[0] = __file__ = path
        execfile(path, globals(), globals())


try:
    _run(('\x00\x00\x00\x00\x01<\x00\x02\x00\x00\x02d1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xbf\xc25\x8cH+\x00\x00\x00b8\x0f\x15AppscriptHelpAgent.py\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00b4\xe4\xc2\xad\xb0\xec\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff\xff\x00\x00I \x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x08\x00\x00\xbf\xc25\x8c\x00\x00\x00\x11\x00\x08\x00\x00\xc2\xad\xa2\xdc\x00\x00\x00\x0e\x00,\x00\x15\x00A\x00p\x00p\x00s\x00c\x00r\x00i\x00p\x00t\x00H\x00e\x00l\x00p\x00A\x00g\x00e\x00n\x00t\x00.\x00p\x00y\x00\x0f\x00\x06\x00\x02\x00d\x001\x00\x12\x00@Users/has/appscript/AppscriptHelpAgent/src/AppscriptHelpAgent.py\x00\x13\x00\x01/\x00\x00\x15\x00\x02\x00\n\xff\xff\x00\x00', '/Users/has/appscript/AppscriptHelpAgent/src/AppscriptHelpAgent.py'))
except KeyboardInterrupt:
    pass
