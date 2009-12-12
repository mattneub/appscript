"""osax.py -- Allows scripting additions (a.k.a. OSAXen) to be called from Python.

(C) 2006-2009 HAS
"""

from appscript import *
from appscript import reference, terminology
import aem

__all__ = ['OSAX', 'scriptingadditions',
		'ScriptingAddition', # deprecated; use OSAX instead
		'ApplicationNotFoundError', 'CommandError', 'k', 'mactypes']


######################################################################
# PRIVATE
######################################################################

class StandardAdditionsGlue:

	classes = \
	[('alert_reply', 'aleR'),
	 ('dialog_reply', 'askr'),
	 ('file_information', 'asfe'),
	 ('POSIX_file', 'psxf'),
	 ('system_information', 'sirr'),
	 ('volume_settings', 'vlst'),
	 ('URL', 'url '),
	 ('Internet_address', 'IPAD'),
	 ('web_page', 'html')]
	
	enums = \
	[('stop', '\x00\x00\x00\x00'),
	 ('note', '\x00\x00\x00\x01'),
	 ('caution', '\x00\x00\x00\x02'),
	 ('IP', 'eipt'),
	 ('AppleTalk', 'eatt'),
	 ('Web_servers', 'esvw'),
	 ('FTP_Servers', 'esvf'),
	 ('Telnet_hosts', 'esvt'),
	 ('File_servers', 'esva'),
	 ('News_servers', 'esvn'),
	 ('Directory_services', 'esvd'),
	 ('Media_servers', 'esvm'),
	 ('Remote_applications', 'esve'),
	 ('critical', 'criT'),
	 ('informational', 'infA'),
	 ('warning', 'warN'),
	 ('current_application', 'agcp'),
	 ('frontmost_application', 'egfp'),
	 ('application_0xD2AppName0xD3', 'agcp'),
	 ('me', 'agcp'),
	 ('it', 'agcp'),
	 ('application_support', 'asup'),
	 ('applications_folder', 'apps'),
	 ('desktop', 'desk'),
	 ('desktop_pictures_folder', 'dtp\xc4'),
	 ('documents_folder', 'docs'),
	 ('downloads_folder', 'down'),
	 ('favorites_folder', 'favs'),
	 ('Folder_Action_scripts', 'fasf'),
	 ('fonts', 'font'),
	 ('help_', '\xc4hlp'),
	 ('home_folder', 'cusr'),
	 ('internet_plugins', '\xc4net'),
	 ('keychain_folder', 'kchn'),
	 ('library_folder', 'dlib'),
	 ('modem_scripts', '\xc4mod'),
	 ('movies_folder', 'mdoc'),
	 ('music_folder', '\xb5doc'),
	 ('pictures_folder', 'pdoc'),
	 ('preferences', 'pref'),
	 ('printer_descriptions', 'ppdf'),
	 ('public_folder', 'pubb'),
	 ('scripting_additions', '\xc4scr'),
	 ('scripts_folder', 'scr\xc4'),
	 ('shared_documents', 'sdat'),
	 ('shared_libraries', '\xc4lib'),
	 ('sites_folder', 'site'),
	 ('startup_disk', 'boot'),
	 ('startup_items', 'empz'),
	 ('system_folder', 'macs'),
	 ('system_preferences', 'sprf'),
	 ('temporary_items', 'temp'),
	 ('trash', 'trsh'),
	 ('users_folder', 'usrs'),
	 ('utilities_folder', 'uti\xc4'),
	 ('workflows_folder', 'flow'),
	 ('voices', 'fvoc'),
	 ('apple_menu', 'amnu'),
	 ('control_panels', 'ctrl'),
	 ('control_strip_modules', 'sdev'),
	 ('extensions', 'extn'),
	 ('launcher_items_folder', 'laun'),
	 ('printer_drivers', '\xc4prd'),
	 ('printmonitor', 'prnt'),
	 ('shutdown_folder', 'shdf'),
	 ('speakable_items', 'spki'),
	 ('stationery', 'odst'),
	 ('application_support_folder', 'asup'),
	 ('current_user_folder', 'cusr'),
	 ('desktop_folder', 'desk'),
	 ('Folder_Action_scripts_folder', 'fasf'),
	 ('fonts_folder', 'font'),
	 ('help_folder', '\xc4hlp'),
	 ('plugins', '\xc4net'),
	 ('internet_plugins_folder', '\xc4net'),
	 ('modem_scripts_folder', '\xc4mod'),
	 ('preferences_folder', 'pref'),
	 ('printer_descriptions_folder', 'ppdf'),
	 ('scripting_additions_folder', '\xc4scr'),
	 ('shared_documents_folder', 'sdat'),
	 ('shared_libraries_folder', '\xc4lib'),
	 ('startup', 'empz'),
	 ('startup_items_folder', 'empz'),
	 ('temporary_items_folder', 'temp'),
	 ('trash_folder', 'trsh'),
	 ('voices_folder', 'fvoc'),
	 ('apple_menu_items', 'amnu'),
	 ('apple_menu_items_folder', 'amnu'),
	 ('control_panels_folder', 'ctrl'),
	 ('control_strip_modules_folder', 'sdev'),
	 ('extensions_folder', 'extn'),
	 ('printer_drivers_folder', '\xc4prd'),
	 ('printmonitor_folder', 'prnt'),
	 ('shutdown_items', 'shdf'),
	 ('shutdown_items_folder', 'shdf'),
	 ('stationery_folder', 'odst'),
	 ('At_Ease_applications', 'apps'),
	 ('At_Ease_applications_folder', 'apps'),
	 ('At_Ease_documents', 'docs'),
	 ('At_Ease_documents_folder', 'docs'),
	 ('editors', 'oded'),
	 ('editors_folder', 'oded'),
	 ('system_domain', 'flds'),
	 ('local_domain', 'fldl'),
	 ('network_domain', 'fldn'),
	 ('user_domain', 'fldu'),
	 ('Classic_domain', 'fldc'),
	 ('short', 'shor'),
	 ('eof', 'eof '),
	 ('boolean', 'bool'),
	 ('ask', 'ask '),
	 ('yes', 'yes '),
	 ('no', 'no  '),
	 ('up', 'rndU'),
	 ('down', 'rndD'),
	 ('toward_zero', 'rndZ'),
	 ('to_nearest', 'rndN'),
	 ('as_taught_in_school', 'rndS'),
	 ('http_URL', 'http'),
	 ('secure_http_URL', 'htps'),
	 ('ftp_URL', 'ftp '),
	 ('mail_URL', 'mail'),
	 ('file_URL_0x28obsolete0x29', 'file'),
	 ('gopher_URL', 'gphr'),
	 ('telnet_URL', 'tlnt'),
	 ('news_URL', 'news'),
	 ('secure_news_URL', 'snws'),
	 ('nntp_URL', 'nntp'),
	 ('message_URL', 'mess'),
	 ('mailbox_URL', 'mbox'),
	 ('multi_URL', 'mult'),
	 ('launch_URL', 'laun'),
	 ('afp_URL', 'afp '),
	 ('AppleTalk_URL', 'at  '),
	 ('remote_application_URL', 'eppc'),
	 ('streaming_multimedia_URL', 'rtsp'),
	 ('network_file_system_URL', 'unfs'),
	 ('mailbox_access_URL', 'imap'),
	 ('mail_server_URL', 'upop'),
	 ('directory_server_URL', 'uldp'),
	 ('unknown_URL', 'url?')]
	
	properties = \
	[('button_returned', 'bhit'),
	 ('gave_up', 'gavu'),
	 ('text_returned', 'ttxt'),
	 ('name', 'pnam'),
	 ('displayed_name', 'dnam'),
	 ('short_name', 'cfbn'),
	 ('name_extension', 'nmxt'),
	 ('bundle_identifier', 'bnid'),
	 ('type_identifier', 'utid'),
	 ('kind', 'kind'),
	 ('default_application', 'asda'),
	 ('creation_date', 'ascd'),
	 ('modification_date', 'asmo'),
	 ('file_type', 'asty'),
	 ('file_creator', 'asct'),
	 ('short_version', 'assv'),
	 ('long_version', 'aslv'),
	 ('size', 'ptsz'),
	 ('alias', 'alis'),
	 ('folder', 'asdr'),
	 ('package_folder', 'ispk'),
	 ('extension_hidden', 'hidx'),
	 ('visible', 'pvis'),
	 ('locked', 'aslk'),
	 ('busy_status', 'bzst'),
	 ('folder_window', 'asfw'),
	 ('POSIX_path', 'psxp'),
	 ('AppleScript_version', 'siav'),
	 ('AppleScript_Studio_version', 'sikv'),
	 ('system_version', 'sisv'),
	 ('short_user_name', 'sisn'),
	 ('long_user_name', 'siln'),
	 ('user_ID', 'siid'),
	 ('user_locale', 'siul'),
	 ('home_directory', 'home'),
	 ('boot_volume', 'sibv'),
	 ('computer_name', 'sicn'),
	 ('host_name', 'ldsa'),
	 ('IPv4_address', 'siip'),
	 ('primary_Ethernet_address', 'siea'),
	 ('CPU_type', 'sict'),
	 ('CPU_speed', 'sics'),
	 ('physical_memory', 'sipm'),
	 ('output_volume', 'ouvl'),
	 ('input_volume', 'invl'),
	 ('alert_volume', 'alvl'),
	 ('output_muted', 'mute'),
	 ('properties', 'pALL'),
	 ('scheme', 'pusc'),
	 ('host', 'HOST'),
	 ('path', 'FTPc'),
	 ('user_name', 'RAun'),
	 ('password', 'RApw'),
	 ('DNS_form', 'pDNS'),
	 ('dotted_decimal_form', 'pipd'),
	 ('port', 'ppor'),
	 ('URL', 'pURL'),
	 ('text_encoding', 'ptxe')]
	
	elements = \
	[('Internet_addresses', 'IPAD'),
	 ('web_pages', 'html'),
	 ('file_information', 'asfe'),
	 ('URL', 'url '),
	 ('dialog_reply', 'askr'),
	 ('alert_reply', 'aleR'),
	 ('system_information', 'sirr'),
	 ('POSIX_file', 'psxf'),
	 ('volume_settings', 'vlst')]
	
	commands = \
	[('display_alert',
	  'sysodisA',
	  [('message', 'mesS'),
	   ('as_', 'as A'),
	   ('buttons', 'btns'),
	   ('default_button', 'dflt'),
	   ('cancel_button', 'cbtn'),
	   ('giving_up_after', 'givu')]),
	 ('get_volume_settings', 'sysogtvl', []),
	 ('the_clipboard', 'JonsgClp', [('as_', 'rtyp')]),
	 ('system_attribute', 'fndrgstl', [('has', 'has ')]),
	 ('set_volume',
	  'aevtstvl',
	  [('output_volume', 'ouvl'),
	   ('input_volume', 'invl'),
	   ('alert_volume', 'alvl'),
	   ('output_muted', 'mute')]),
	 ('info_for', 'sysonfo4', [('size', 'ptsz')]),
	 ('system_info', 'sysosigt', []),
	 ('get_eof', 'rdwrgeof', []),
	 ('choose_from_list',
	  'gtqpchlt',
	  [('with_title', 'appr'),
	   ('with_prompt', 'prmp'),
	   ('default_items', 'inSL'),
	   ('OK_button_name', 'okbt'),
	   ('cancel_button_name', 'cnbt'),
	   ('multiple_selections_allowed', 'mlsl'),
	   ('empty_selection_allowed', 'empL')]),
	 ('say',
	  'sysottos',
	  [('displaying', 'DISP'),
	   ('using', 'VOIC'),
	   ('speaking_rate', 'RATE'),
	   ('pitch', 'PTCH'),
	   ('modulation', 'PMOD'),
	   ('volume', 'VOLU'),
	   ('stopping_current_speech', 'STOP'),
	   ('waiting_until_completion', 'wfsp'),
	   ('saving_to', 'stof')]),
	 ('computer', 'fndrgstl', [('has', 'has ')]),
	 ('handle_CGI_request',
	  'WWW\xbdsdoc',
	  [('searching_for', 'kfor'),
	   ('with_posted_data', 'post'),
	   ('of_content_type', 'ctyp'),
	   ('using_access_method', 'meth'),
	   ('from_address', 'addr'),
	   ('from_user', 'user'),
	   ('using_password', 'pass'),
	   ('with_user_info', 'frmu'),
	   ('from_server', 'svnm'),
	   ('via_port', 'svpt'),
	   ('executing_by', 'scnm'),
	   ('referred_by', 'refr'),
	   ('from_browser', 'Agnt'),
	   ('using_action', 'Kapt'),
	   ('of_action_type', 'Kact'),
	   ('from_client_IP_address', 'Kcip'),
	   ('with_full_request', 'Kfrq'),
	   ('with_connection_ID', 'Kcid'),
	   ('from_virtual_host', 'DIRE')]),
	 ('scripting_components', 'sysocpls', []),
	 ('run_script', 'sysodsct', [('with_parameters', 'plst'), ('in_', 'scsy')]),
	 ('beep', 'sysobeep', []),
	 ('mount_volume',
	  'aevtmvol',
	  [('on_server', 'SRVR'),
	   ('in_AppleTalk_zone', 'ZONE'),
	   ('as_user_name', 'USER'),
	   ('with_password', 'PASS')]),
	 ('write',
	  'rdwrwrit',
	  [('to', 'refn'),
	   ('starting_at', 'wrat'),
	   ('for_', 'nmwr'),
	   ('as_', 'as  ')]),
	 ('path_to',
	  'earsffdr',
	  [('from_', 'from'), ('as_', 'rtyp'), ('folder_creation', 'crfl')]),
	 ('list_disks', 'earslvol', []),
	 ('random_number',
	  'sysorand',
	  [('from_', 'from'), ('to', 'to  '), ('with_seed', 'seed')]),
	 ('time_to_GMT', 'sysoGMT ', []),
	 ('delay', 'sysodela', []),
	 ('current_date', 'misccurd', []),
	 ('ASCII_number', 'sysocton', []),
	 ('list_folder', 'earslfdr', [('invisibles', 'lfiv')]),
	 ('choose_file',
	  'sysostdf',
	  [('with_prompt', 'prmp'),
	   ('of_type', 'ftyp'),
	   ('default_location', 'dflc'),
	   ('invisibles', 'lfiv'),
	   ('multiple_selections_allowed', 'mlsl'),
	   ('showing_package_contents', 'shpc')]),
	 ('close_access', 'rdwrclos', []),
	 ('open_location', 'GURLGURL', [('error_reporting', 'errr')]),
	 ('ASCII_character', 'sysontoc', []),
	 ('do_shell_script',
	  'sysoexec',
	  [('as_', 'rtyp'),
	   ('administrator_privileges', 'badm'),
	   ('user_name', 'RAun'),
	   ('password', 'RApw'),
	   ('altering_line_endings', 'alen')]),
	 ('closing_folder_window_for', 'facofclo', []),
	 ('choose_folder',
	  'sysostfl',
	  [('with_prompt', 'prmp'),
	   ('default_location', 'dflc'),
	   ('invisibles', 'lfiv'),
	   ('multiple_selections_allowed', 'mlsl'),
	   ('showing_package_contents', 'shpc')]),
	 ('localized_string',
	  'sysolocS',
	  [('from_table', 'froT'), ('in_bundle', 'in B')]),
	 ('read',
	  'rdwrread',
	  [('from_', 'rdfm'),
	   ('for_', 'rdfr'),
	   ('to', 'rdto'),
	   ('before_', 'rbfr'),
	   ('until', 'rdut'),
	   ('using_delimiter', 'deli'),
	   ('using_delimiters', 'deli'),
	   ('as_', 'as  ')]),
	 ('choose_color', 'sysochcl', [('default_color', 'dcol')]),
	 ('set_the_clipboard_to', 'JonspClp', []),
	 ('choose_file_name',
	  'sysonwfl',
	  [('with_prompt', 'prmt'),
	   ('default_name', 'dfnm'),
	   ('default_location', 'dflc')]),
	 ('choose_URL', 'sysochur', [('showing', 'cusv'), ('editable_URL', 'pedu')]),
	 ('choose_remote_application',
	  'sysochra',
	  [('with_title', 'appr'), ('with_prompt', 'prmp')]),
	 ('offset', 'sysooffs', [('of', 'psof'), ('in_', 'psin')]),
	 ('opening_folder', 'facofopn', []),
	 ('summarize', 'fbcssumm', [('in_', 'in  ')]),
	 ('moving_folder_window_for', 'facofsiz', [('from_', 'fnsz')]),
	 ('removing_folder_items_from', 'facoflos', [('after_losing', 'flst')]),
	 ('path_to_resource',
	  'sysorpth',
	  [('in_bundle', 'in B'), ('in_directory', 'in D')]),
	 ('store_script', 'sysostor', [('in_', 'fpth'), ('replacing', 'savo')]),
	 ('adding_folder_items_to', 'facofget', [('after_receiving', 'flst')]),
	 ('choose_application',
	  'sysoppcb',
	  [('with_title', 'appr'),
	   ('with_prompt', 'prmp'),
	   ('multiple_selections_allowed', 'mlsl'),
	   ('as_', 'rtyp')]),
	 ('clipboard_info', 'JonsiClp', [('for_', 'for ')]),
	 ('set_eof', 'rdwrseof', [('to', 'set2')]),
	 ('open_for_access', 'rdwropen', [('write_permission', 'perm')]),
	 ('load_script', 'sysoload', []),
	 ('display_dialog',
	  'sysodlog',
	  [('default_answer', 'dtxt'),
	   ('hidden_answer', 'htxt'),
	   ('buttons', 'btns'),
	   ('default_button', 'dflt'),
	   ('cancel_button', 'cbtn'),
	   ('with_title', 'appr'),
	   ('with_icon', 'disp'),
	   ('with_icon', 'disp'),
	   ('with_icon', 'disp'),
	   ('giving_up_after', 'givu')]),
	 ('round', 'sysorond', [('rounding', 'dire')])]
 

######################################################################


_osaxcache = {} # a dict of form: {'osax name': ['/path/to/osax', cached_terms_or_None], ...}

_osaxnames = [] # names of all currently available osaxen

def _initcaches():
		_se = aem.Application(aem.findapp.byid('com.apple.systemevents'))
		for domaincode in ['flds', 'fldl', 'fldu']:
			osaxen = aem.app.property(domaincode).property('$scr').elements('file').byfilter(
					aem.its.property('asty').eq('osax').OR(aem.its.property('extn').eq('osax')))
			if _se.event('coredoex', {'----': osaxen.property('pnam')}).send(): # domain has ScriptingAdditions folder
				names = _se.event('coregetd', {'----': osaxen.property('pnam')}).send()
				paths = _se.event('coregetd', {'----': osaxen.property('posx')}).send()
				for name, path in zip(names, paths):
					if name.lower().endswith('.osax'): # remove name extension, if any
						name = name[:-5]
					if name.lower() not in _osaxcache:
						_osaxnames.append(name)
						_osaxcache[name.lower()] = [path, None]
		_osaxnames.sort()


######################################################################
# PUBLIC
######################################################################

def scriptingadditions():
	if not _osaxnames:
		_initcaches()
	return _osaxnames[:]


class OSAX(reference.Application):

	def __init__(self, osaxname='StandardAdditions', name=None, id=None, creator=None, pid=None, url=None, aemapp=None, terms=True):
		if not _osaxcache:
			_initcaches()
		self._osaxname = osaxname
		osaxname = osaxname.lower()
		if osaxname.endswith('.osax'):
			osaxname = osaxname[:-5]
		if terms == True:
			try:
				osaxpath, terms = _osaxcache[osaxname]
			except KeyError:
				raise ValueError("Scripting addition not found: %r" % self._osaxname)
			if not terms:
				try:
					aete = aem.ae.getappterminology(osaxpath)
				except NotImplementedError:
					if osaxname == 'standardadditions':
						terms = _osaxcache[osaxname][1] = terminology.tablesformodule(StandardAdditionsGlue)
					else:
						raise
				else:
					terms = _osaxcache[osaxname][1] = terminology.tablesforaetes(aete)
		reference.Application.__init__(self, name, id, creator, pid, url, aemapp, terms)
		try:
			self.AS_appdata.target().event('ascrgdut').send(300) # make sure target application has loaded event handlers for all installed OSAXen
		except aem.EventError, e:
			if e.errornumber != -1708: # ignore 'event not handled' error
				raise
		def _help(*args):
			raise NotImplementedError("Built-in help isn't available for scripting additions.")
		self.AS_appdata.help = _help
		
	def __str__(self):
		if self.AS_appdata.constructor == 'current':
			return 'OSAX(%r)' % self._osaxname
		elif self.AS_appdata.constructor == 'path':
			return 'OSAX(%r, %r)' % (self._osaxname, self.AS_appdata.identifier)
		else:
			return 'OSAX(%r, %s=%r)' % (self._osaxname, self.AS_appdata.constructor, self.AS_appdata.identifier)
		
	__repr__ = __str__


ScriptingAddition = OSAX # deprecated but retained for backwards compatibility

