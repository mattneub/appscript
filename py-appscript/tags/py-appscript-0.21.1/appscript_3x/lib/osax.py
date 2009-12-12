"""osax.py -- Allows scripting additions (a.k.a. OSAXen) to be called from Python.

(C) 2006-2009 HAS
"""

from appscript import *
from appscript import reference, terminology
import aem

__all__ = ['OSAX', 'scriptingadditions', 'ApplicationNotFoundError', 'CommandError', 'k', 'mactypes']


######################################################################
# PRIVATE
######################################################################

class StandardAdditionsGlue:

	classes = \
	[('alert_reply', b'aleR'),
	 ('dialog_reply', b'askr'),
	 ('file_information', b'asfe'),
	 ('POSIX_file', b'psxf'),
	 ('system_information', b'sirr'),
	 ('volume_settings', b'vlst'),
	 ('URL', b'url '),
	 ('Internet_address', b'IPAD'),
	 ('web_page', b'html')]
	
	enums = \
	[('stop', b'\x00\x00\x00\x00'),
	 ('note', b'\x00\x00\x00\x01'),
	 ('caution', b'\x00\x00\x00\x02'),
	 ('IP', b'eipt'),
	 ('AppleTalk', b'eatt'),
	 ('Web_servers', b'esvw'),
	 ('FTP_Servers', b'esvf'),
	 ('Telnet_hosts', b'esvt'),
	 ('File_servers', b'esva'),
	 ('News_servers', b'esvn'),
	 ('Directory_services', b'esvd'),
	 ('Media_servers', b'esvm'),
	 ('Remote_applications', b'esve'),
	 ('critical', b'criT'),
	 ('informational', b'infA'),
	 ('warning', b'warN'),
	 ('current_application', b'agcp'),
	 ('frontmost_application', b'egfp'),
	 ('application_0xD2AppName0xD3', b'agcp'),
	 ('me', b'agcp'),
	 ('it', b'agcp'),
	 ('application_support', b'asup'),
	 ('applications_folder', b'apps'),
	 ('desktop', b'desk'),
	 ('desktop_pictures_folder', b'dtp\xc4'),
	 ('documents_folder', b'docs'),
	 ('downloads_folder', b'down'),
	 ('favorites_folder', b'favs'),
	 ('Folder_Action_scripts', b'fasf'),
	 ('fonts', b'font'),
	 ('help_', b'\xc4hlp'),
	 ('home_folder', b'cusr'),
	 ('internet_plugins', b'\xc4net'),
	 ('keychain_folder', b'kchn'),
	 ('library_folder', b'dlib'),
	 ('modem_scripts', b'\xc4mod'),
	 ('movies_folder', b'mdoc'),
	 ('music_folder', b'\xb5doc'),
	 ('pictures_folder', b'pdoc'),
	 ('preferences', b'pref'),
	 ('printer_descriptions', b'ppdf'),
	 ('public_folder', b'pubb'),
	 ('scripting_additions', b'\xc4scr'),
	 ('scripts_folder', b'scr\xc4'),
	 ('shared_documents', b'sdat'),
	 ('shared_libraries', b'\xc4lib'),
	 ('sites_folder', b'site'),
	 ('startup_disk', b'boot'),
	 ('startup_items', b'empz'),
	 ('system_folder', b'macs'),
	 ('system_preferences', b'sprf'),
	 ('temporary_items', b'temp'),
	 ('trash', b'trsh'),
	 ('users_folder', b'usrs'),
	 ('utilities_folder', b'uti\xc4'),
	 ('workflows_folder', b'flow'),
	 ('voices', b'fvoc'),
	 ('apple_menu', b'amnu'),
	 ('control_panels', b'ctrl'),
	 ('control_strip_modules', b'sdev'),
	 ('extensions', b'extn'),
	 ('launcher_items_folder', b'laun'),
	 ('printer_drivers', b'\xc4prd'),
	 ('printmonitor', b'prnt'),
	 ('shutdown_folder', b'shdf'),
	 ('speakable_items', b'spki'),
	 ('stationery', b'odst'),
	 ('application_support_folder', b'asup'),
	 ('current_user_folder', b'cusr'),
	 ('desktop_folder', b'desk'),
	 ('Folder_Action_scripts_folder', b'fasf'),
	 ('fonts_folder', b'font'),
	 ('help_folder', b'\xc4hlp'),
	 ('plugins', b'\xc4net'),
	 ('internet_plugins_folder', b'\xc4net'),
	 ('modem_scripts_folder', b'\xc4mod'),
	 ('preferences_folder', b'pref'),
	 ('printer_descriptions_folder', b'ppdf'),
	 ('scripting_additions_folder', b'\xc4scr'),
	 ('shared_documents_folder', b'sdat'),
	 ('shared_libraries_folder', b'\xc4lib'),
	 ('startup', b'empz'),
	 ('startup_items_folder', b'empz'),
	 ('temporary_items_folder', b'temp'),
	 ('trash_folder', b'trsh'),
	 ('voices_folder', b'fvoc'),
	 ('apple_menu_items', b'amnu'),
	 ('apple_menu_items_folder', b'amnu'),
	 ('control_panels_folder', b'ctrl'),
	 ('control_strip_modules_folder', b'sdev'),
	 ('extensions_folder', b'extn'),
	 ('printer_drivers_folder', b'\xc4prd'),
	 ('printmonitor_folder', b'prnt'),
	 ('shutdown_items', b'shdf'),
	 ('shutdown_items_folder', b'shdf'),
	 ('stationery_folder', b'odst'),
	 ('At_Ease_applications', b'apps'),
	 ('At_Ease_applications_folder', b'apps'),
	 ('At_Ease_documents', b'docs'),
	 ('At_Ease_documents_folder', b'docs'),
	 ('editors', b'oded'),
	 ('editors_folder', b'oded'),
	 ('system_domain', b'flds'),
	 ('local_domain', b'fldl'),
	 ('network_domain', b'fldn'),
	 ('user_domain', b'fldu'),
	 ('Classic_domain', b'fldc'),
	 ('short', b'shor'),
	 ('eof', b'eof '),
	 ('boolean', b'bool'),
	 ('ask', b'ask '),
	 ('yes', b'yes '),
	 ('no', b'no  '),
	 ('up', b'rndU'),
	 ('down', b'rndD'),
	 ('toward_zero', b'rndZ'),
	 ('to_nearest', b'rndN'),
	 ('as_taught_in_school', b'rndS'),
	 ('http_URL', b'http'),
	 ('secure_http_URL', b'htps'),
	 ('ftp_URL', b'ftp '),
	 ('mail_URL', b'mail'),
	 ('file_URL_0x28obsolete0x29', b'file'),
	 ('gopher_URL', b'gphr'),
	 ('telnet_URL', b'tlnt'),
	 ('news_URL', b'news'),
	 ('secure_news_URL', b'snws'),
	 ('nntp_URL', b'nntp'),
	 ('message_URL', b'mess'),
	 ('mailbox_URL', b'mbox'),
	 ('multi_URL', b'mult'),
	 ('launch_URL', b'laun'),
	 ('afp_URL', b'afp '),
	 ('AppleTalk_URL', b'at  '),
	 ('remote_application_URL', b'eppc'),
	 ('streaming_multimedia_URL', b'rtsp'),
	 ('network_file_system_URL', b'unfs'),
	 ('mailbox_access_URL', b'imap'),
	 ('mail_server_URL', b'upop'),
	 ('directory_server_URL', b'uldp'),
	 ('unknown_URL', b'url?')]
	
	properties = \
	[('button_returned', b'bhit'),
	 ('gave_up', b'gavu'),
	 ('text_returned', b'ttxt'),
	 ('name', b'pnam'),
	 ('displayed_name', b'dnam'),
	 ('short_name', b'cfbn'),
	 ('name_extension', b'nmxt'),
	 ('bundle_identifier', b'bnid'),
	 ('type_identifier', b'utid'),
	 ('kind', b'kind'),
	 ('default_application', b'asda'),
	 ('creation_date', b'ascd'),
	 ('modification_date', b'asmo'),
	 ('file_type', b'asty'),
	 ('file_creator', b'asct'),
	 ('short_version', b'assv'),
	 ('long_version', b'aslv'),
	 ('size', b'ptsz'),
	 ('alias', b'alis'),
	 ('folder', b'asdr'),
	 ('package_folder', b'ispk'),
	 ('extension_hidden', b'hidx'),
	 ('visible', b'pvis'),
	 ('locked', b'aslk'),
	 ('busy_status', b'bzst'),
	 ('folder_window', b'asfw'),
	 ('POSIX_path', b'psxp'),
	 ('AppleScript_version', b'siav'),
	 ('AppleScript_Studio_version', b'sikv'),
	 ('system_version', b'sisv'),
	 ('short_user_name', b'sisn'),
	 ('long_user_name', b'siln'),
	 ('user_ID', b'siid'),
	 ('user_locale', b'siul'),
	 ('home_directory', b'home'),
	 ('boot_volume', b'sibv'),
	 ('computer_name', b'sicn'),
	 ('host_name', b'ldsa'),
	 ('IPv4_address', b'siip'),
	 ('primary_Ethernet_address', b'siea'),
	 ('CPU_type', b'sict'),
	 ('CPU_speed', b'sics'),
	 ('physical_memory', b'sipm'),
	 ('output_volume', b'ouvl'),
	 ('input_volume', b'invl'),
	 ('alert_volume', b'alvl'),
	 ('output_muted', b'mute'),
	 ('properties', b'pALL'),
	 ('scheme', b'pusc'),
	 ('host', b'HOST'),
	 ('path', b'FTPc'),
	 ('user_name', b'RAun'),
	 ('password', b'RApw'),
	 ('DNS_form', b'pDNS'),
	 ('dotted_decimal_form', b'pipd'),
	 ('port', b'ppor'),
	 ('URL', b'pURL'),
	 ('text_encoding', b'ptxe')]
	
	elements = \
	[('Internet_addresses', b'IPAD'),
	 ('web_pages', b'html'),
	 ('file_information', b'asfe'),
	 ('URL', b'url '),
	 ('dialog_reply', b'askr'),
	 ('alert_reply', b'aleR'),
	 ('system_information', b'sirr'),
	 ('POSIX_file', b'psxf'),
	 ('volume_settings', b'vlst')]
	
	commands = \
	[('display_alert',
	  b'sysodisA',
	  [('message', b'mesS'),
	   ('as_', b'as A'),
	   ('buttons', b'btns'),
	   ('default_button', b'dflt'),
	   ('cancel_button', b'cbtn'),
	   ('giving_up_after', b'givu')]),
	 ('get_volume_settings', b'sysogtvl', []),
	 ('the_clipboard', b'JonsgClp', [('as_', b'rtyp')]),
	 ('system_attribute', b'fndrgstl', [('has', b'has ')]),
	 ('set_volume',
	  b'aevtstvl',
	  [('output_volume', b'ouvl'),
	   ('input_volume', b'invl'),
	   ('alert_volume', b'alvl'),
	   ('output_muted', b'mute')]),
	 ('info_for', b'sysonfo4', [('size', b'ptsz')]),
	 ('system_info', b'sysosigt', []),
	 ('get_eof', b'rdwrgeof', []),
	 ('choose_from_list',
	  b'gtqpchlt',
	  [('with_title', b'appr'),
	   ('with_prompt', b'prmp'),
	   ('default_items', b'inSL'),
	   ('OK_button_name', b'okbt'),
	   ('cancel_button_name', b'cnbt'),
	   ('multiple_selections_allowed', b'mlsl'),
	   ('empty_selection_allowed', b'empL')]),
	 ('say',
	  b'sysottos',
	  [('displaying', b'DISP'),
	   ('using', b'VOIC'),
	   ('speaking_rate', b'RATE'),
	   ('pitch', b'PTCH'),
	   ('modulation', b'PMOD'),
	   ('volume', b'VOLU'),
	   ('stopping_current_speech', b'STOP'),
	   ('waiting_until_completion', b'wfsp'),
	   ('saving_to', b'stof')]),
	 ('computer', b'fndrgstl', [('has', b'has ')]),
	 ('handle_CGI_request',
	  b'WWW\xbdsdoc',
	  [('searching_for', b'kfor'),
	   ('with_posted_data', b'post'),
	   ('of_content_type', b'ctyp'),
	   ('using_access_method', b'meth'),
	   ('from_address', b'addr'),
	   ('from_user', b'user'),
	   ('using_password', b'pass'),
	   ('with_user_info', b'frmu'),
	   ('from_server', b'svnm'),
	   ('via_port', b'svpt'),
	   ('executing_by', b'scnm'),
	   ('referred_by', b'refr'),
	   ('from_browser', b'Agnt'),
	   ('using_action', b'Kapt'),
	   ('of_action_type', b'Kact'),
	   ('from_client_IP_address', b'Kcip'),
	   ('with_full_request', b'Kfrq'),
	   ('with_connection_ID', b'Kcid'),
	   ('from_virtual_host', b'DIRE')]),
	 ('scripting_components', b'sysocpls', []),
	 ('run_script', b'sysodsct', [('with_parameters', b'plst'), ('in_', b'scsy')]),
	 ('beep', b'sysobeep', []),
	 ('mount_volume',
	  b'aevtmvol',
	  [('on_server', b'SRVR'),
	   ('in_AppleTalk_zone', b'ZONE'),
	   ('as_user_name', b'USER'),
	   ('with_password', b'PASS')]),
	 ('write',
	  b'rdwrwrit',
	  [('to', b'refn'),
	   ('starting_at', b'wrat'),
	   ('for_', b'nmwr'),
	   ('as_', b'as  ')]),
	 ('path_to',
	  b'earsffdr',
	  [('from_', b'from'), ('as_', b'rtyp'), ('folder_creation', b'crfl')]),
	 ('list_disks', b'earslvol', []),
	 ('random_number',
	  b'sysorand',
	  [('from_', b'from'), ('to', b'to  '), ('with_seed', b'seed')]),
	 ('time_to_GMT', b'sysoGMT ', []),
	 ('delay', b'sysodela', []),
	 ('current_date', b'misccurd', []),
	 ('ASCII_number', b'sysocton', []),
	 ('list_folder', b'earslfdr', [('invisibles', b'lfiv')]),
	 ('choose_file',
	  b'sysostdf',
	  [('with_prompt', b'prmp'),
	   ('of_type', b'ftyp'),
	   ('default_location', b'dflc'),
	   ('invisibles', b'lfiv'),
	   ('multiple_selections_allowed', b'mlsl'),
	   ('showing_package_contents', b'shpc')]),
	 ('close_access', b'rdwrclos', []),
	 ('open_location', b'GURLGURL', [('error_reporting', b'errr')]),
	 ('ASCII_character', b'sysontoc', []),
	 ('do_shell_script',
	  b'sysoexec',
	  [('as_', b'rtyp'),
	   ('administrator_privileges', b'badm'),
	   ('user_name', b'RAun'),
	   ('password', b'RApw'),
	   ('altering_line_endings', b'alen')]),
	 ('closing_folder_window_for', b'facofclo', []),
	 ('choose_folder',
	  b'sysostfl',
	  [('with_prompt', b'prmp'),
	   ('default_location', b'dflc'),
	   ('invisibles', b'lfiv'),
	   ('multiple_selections_allowed', b'mlsl'),
	   ('showing_package_contents', b'shpc')]),
	 ('localized_string',
	  b'sysolocS',
	  [('from_table', b'froT'), ('in_bundle', b'in B')]),
	 ('read',
	  b'rdwrread',
	  [('from_', b'rdfm'),
	   ('for_', b'rdfr'),
	   ('to', b'rdto'),
	   ('before_', b'rbfr'),
	   ('until', b'rdut'),
	   ('using_delimiter', b'deli'),
	   ('using_delimiters', b'deli'),
	   ('as_', b'as  ')]),
	 ('choose_color', b'sysochcl', [('default_color', b'dcol')]),
	 ('set_the_clipboard_to', b'JonspClp', []),
	 ('choose_file_name',
	  b'sysonwfl',
	  [('with_prompt', b'prmt'),
	   ('default_name', b'dfnm'),
	   ('default_location', b'dflc')]),
	 ('choose_URL', b'sysochur', [('showing', b'cusv'), ('editable_URL', b'pedu')]),
	 ('choose_remote_application',
	  b'sysochra',
	  [('with_title', b'appr'), ('with_prompt', b'prmp')]),
	 ('offset', b'sysooffs', [('of', b'psof'), ('in_', b'psin')]),
	 ('opening_folder', b'facofopn', []),
	 ('summarize', b'fbcssumm', [('in_', b'in  ')]),
	 ('moving_folder_window_for', b'facofsiz', [('from_', b'fnsz')]),
	 ('removing_folder_items_from', b'facoflos', [('after_losing', b'flst')]),
	 ('path_to_resource',
	  b'sysorpth',
	  [('in_bundle', b'in B'), ('in_directory', b'in D')]),
	 ('store_script', b'sysostor', [('in_', b'fpth'), ('replacing', b'savo')]),
	 ('adding_folder_items_to', b'facofget', [('after_receiving', b'flst')]),
	 ('choose_application',
	  b'sysoppcb',
	  [('with_title', b'appr'),
	   ('with_prompt', b'prmp'),
	   ('multiple_selections_allowed', b'mlsl'),
	   ('as_', b'rtyp')]),
	 ('clipboard_info', b'JonsiClp', [('for_', b'for ')]),
	 ('set_eof', b'rdwrseof', [('to', b'set2')]),
	 ('open_for_access', b'rdwropen', [('write_permission', b'perm')]),
	 ('load_script', b'sysoload', []),
	 ('display_dialog',
	  b'sysodlog',
	  [('default_answer', b'dtxt'),
	   ('hidden_answer', b'htxt'),
	   ('buttons', b'btns'),
	   ('default_button', b'dflt'),
	   ('cancel_button', b'cbtn'),
	   ('with_title', b'appr'),
	   ('with_icon', b'disp'),
	   ('with_icon', b'disp'),
	   ('with_icon', b'disp'),
	   ('giving_up_after', b'givu')]),
	 ('round', b'sysorond', [('rounding', b'dire')])]
 

######################################################################


_osaxcache = {} # a dict of form: {'osax name': ['/path/to/osax', cached_terms_or_None], ...}

_osaxnames = [] # names of all currently available osaxen

def _initcaches():
		_se = aem.Application(aem.findapp.byid('com.apple.systemevents'))
		for domaincode in [b'flds', b'fldl', b'fldu']:
			osaxen = aem.app.property(domaincode).property(b'$scr').elements(b'file').byfilter(
					aem.its.property(b'asty').eq('osax').OR(aem.its.property(b'extn').eq('osax')))
			if _se.event(b'coredoex', {b'----': osaxen.property(b'pnam')}).send(): # domain has ScriptingAdditions folder
				names = _se.event(b'coregetd', {b'----': osaxen.property(b'pnam')}).send()
				paths = _se.event(b'coregetd', {b'----': osaxen.property(b'posx')}).send()
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
				raise ValueError("Scripting addition not found: {!r}".format(self._osaxname))
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
			self.AS_appdata.target().event(b'ascrgdut').send(300) # make sure target application has loaded event handlers for all installed OSAXen
		except aem.EventError as e:
			if e.errornumber != -1708: # ignore 'event not handled' error
				raise
		def _help(*args):
			raise NotImplementedError("Built-in help isn't available for scripting additions.")
		self.AS_appdata.help = _help
		
	def __str__(self):
		if self.AS_appdata.constructor == 'current':
			return 'OSAX({!r})'.format(self._osaxname)
		elif self.AS_appdata.constructor == 'path':
			return 'OSAX({!r}, {!r})'.format(self._osaxname, self.AS_appdata.identifier)
		else:
			return 'OSAX({!r}, {}={!r})'.format(self._osaxname, self.AS_appdata.constructor, self.AS_appdata.identifier)
		
	__repr__ = __str__

