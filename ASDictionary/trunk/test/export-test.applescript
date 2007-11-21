tell application "ASDictionary"
	export dictionaries {"/Applications/Mail.app" as POSIX file, Â
		"/Applications/TextEdit.app" as POSIX file, Â
		"/Applications/Chess.app" as POSIX file} Â
		to ("/Users/has/test" as POSIX file) Â
		using file formats {plain text, single file HTML, frame based HTML} Â
		using styles {AppleScript, Python appscript, Ruby appscript, ObjC appscript} Â
		with compacting classes, showing hidden items and exporting to subfolders
end tell
