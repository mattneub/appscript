tell application "ASDictionary"
	export {Â
		POSIX file "/Applications/Mail.app", Â
		POSIX file "/Applications/TextEdit.app", Â
		POSIX file "/Applications/Chess.app"} Â
		to (POSIX file "/Users/has/test") Â
		using file formats {plain text, single file HTML, frame based HTML, ObjC appscript glue} Â
		using styles {AppleScript, Python appscript, Ruby appscript, ObjC appscript} Â
		with compacting classes, showing hidden items and exporting to subfolders
end tell