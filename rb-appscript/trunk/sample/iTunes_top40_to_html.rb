#!/usr/local/bin/ruby

# This script renders the track and album names of the  top 40 most played
# iTunes tracks to an HTML file, then opens it in Safari.
#
# Requires the Amrita templating engine: http://amrita.sourceforge.jp

require 'appscript'
require 'osax'
require "amrita/template"
include Amrita

# Amrita HTML template
tmpl = TemplateText.new <<END
<html>
<head>
<title>My iTunes Top 40</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<table border="1">
	<thead>
	<tr><th>Played</th><th>Album</th><th>Artist</th></tr>
	</thead>
	<tbody>
	<tr id="table_row"><td id="table_column"></td></tr>
	</tbody>
</table>
</body>
</html>
END

# Choose the file to write
sa = OSAX.osax('StandardAdditions')
out_file = sa.choose_file_name(:default_name=>'My iTunes Top 40.html')

# Get the played count, album and name for every track in iTunes
tracks = AS.app('iTunes').library_playlists[1].tracks
info = tracks.played_count.get.zip(tracks.album.get, tracks.name.get)
# Extract the top 40 most played entries
top40 = info.sort.reverse[0, 40]

# Assemble input data for Amrita
data = {
	:table_row=>top40.collect { |row_data| {:table_column=>row_data} }
}

# Render HTML file
tmpl.prettyprint = true
File.open(out_file.to_s, 'w') { |f| tmpl.expand(f, data) }

# Open file in Safari for viewing
safari = AS.app('Safari')
safari.activate
safari.open(out_file)


