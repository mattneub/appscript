#!/usr/bin/env python

from appscript import app, k

def makeMessage(addresses, subject, content, showWindow=False):
    """Make an outgoing message in Mail.
        addresses : list of unicode -- a list of email addresses
        subject : unicode -- the message subject
        content : unicode -- the message content
        showWindow : Boolean -- show message window in Mail
        Result : reference -- reference to the new outgoing message
   	"""
    mail = app('Mail')
    msg = mail.make(
            new=k.outgoing_message, 
            with_properties={k.visible: showWindow})
    for anAddress in addresses:
        msg.to_recipients.end.make(
                new=k.recipient, 
                with_properties={k.address: anAddress})
    msg.subject.set(subject)
    msg.content.set(content)
    return msg


# test
print makeMessage(['joe@foo.com', 'jane@bar.net'],
        'Hello World', 'Some body text.', True)