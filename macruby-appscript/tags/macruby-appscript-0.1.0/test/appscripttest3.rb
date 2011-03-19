#!/usr/local/bin/macruby

require 'appscript'

te = Appscript.app('TextEdit')

te.documents.end.make(new: :document)
p te.documents[1].text.set('foo') == te.text.get 
# -> true   -- this should be false!

# Problem: MacRuby doesn't distinguish between NULLs and NSNulls, so can't tell if an error occurred (NULL) or if application simply didn't provide a return value (NSNull)