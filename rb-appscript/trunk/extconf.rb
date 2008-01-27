# appscript install script
# Based on RubyOSA extconf.rb
# Original copyright below:
#
# Copyright (c) 2006, Apple Computer, Inc. All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1.  Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer. 
# 2.  Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution. 
# 3.  Neither the name of Apple Computer, Inc. ("Apple") nor the names of
#     its contributors may be used to endorse or promote products derived
#     from this software without specific prior written permission. 
# 
# THIS SOFTWARE IS PROVIDED BY APPLE AND ITS CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL APPLE OR ITS CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

require 'mkmf'

$CFLAGS << ' -Wall'
$LDFLAGS << ' -framework Carbon -framework ApplicationServices'

# Avoid `ID' and `T_DATA' symbol collisions between Ruby and Carbon.
# (adapted code from RubyAEOSA - FUJIMOTO Hisakuni  <hisa -at- fobj - com>)

maj, min, rev = RUBY_VERSION.split('.')
is_ruby_18 = (maj == '1' and min.to_i < 9)
if is_ruby_18
	header_path = Config::CONFIG['archdir']
else
	header_path = File.join(Config::CONFIG['rubyhdrdir'], 'ruby')
end
ruby_h = File.join(header_path, 'ruby.h')
intern_h = File.join(header_path, 'intern.h')
new_filename_prefix = 'osx_'

[ ruby_h, intern_h ].each do |src_path|
    dst_fname = File.join('./src', new_filename_prefix + File.basename(src_path))
    $stderr.puts "create #{File.expand_path(dst_fname)} ..."
    File.open(dst_fname, 'w') do |dstfile|
        IO.foreach(src_path) do |line|
            line = line.gsub(/\bID\b/, 'RB_ID')
            line = line.gsub(/\bT_DATA\b/, 'RB_T_DATA')
            line = line.gsub(/\b(?:ruby\/)?intern.h\b/, "#{new_filename_prefix}intern.h")
            line = line.gsub('#include "defines.h"', '#include "ruby/defines.h"') if not is_ruby_18
            dstfile.puts line
        end
    end
end

create_makefile('ae', 'src')
