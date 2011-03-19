#!/usr/local/bin/macruby

require 'pp'
require 'appscript';# include Appscript

a = Appscript.app('TextEdit')

p a.documents.text.get

p a.documents.end.make(new: :document)

p a.documents.get(:wait_reply => true)

p a.get(Appscript.app.documents)

p a.get(Appscript.app.documents, :wait_reply => true)

p a.documents[1].close

