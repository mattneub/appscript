#!/usr/bin/env ruby

# This script renders the track and album names of the  top 40 most played
# iTunes tracks to an HTML file, then opens it in Safari.
#
# Requires the Amrita templating engine: http://amrita.sourceforge.jp

# Note: if using the appscript gem, rubygems must be required first:
begin; require 'rubygems'; rescue LoadError; end

require 'appscript'
include Appscript
require 'osax'
require "amrita/template"
include Amrita

# Amrita HTML template
tmpl = TemplateText.new <<END
<html>
<head>
<title> iTunes Top 40 Tracks</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css" media="all">
	body {padding:0; margin:0;}
	table {color:black; background-color:#448; width:100%; padding:2px;}
	th, td {padding:2px; border-width:0;}
	th {color:#fff; background-color:#114;}
	td {color:black; background-color:#bbd;}
</style>
</head>
<body>
<table border="1">
	<thead>
	<tr><th>#</th><th>Track</th><th>Album</th></tr>
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
out_file = sa.choose_file_name(:default_name=>'My-iTunes-Top-40.html')

# Get the played count, name and album for every track in iTunes
tracks = app('iTunes').library_playlists[1].tracks
info = tracks.played_count.get.zip(tracks.name.get, tracks.album.get)
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
# safari = app('Safari')
# safari.activate
# safari.open(out_file)

# Open file in default web browser for viewing
sa.open_location(out_file.url)


