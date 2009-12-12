#!/usr/bin/env python3

# Compose an outgoing message in Apple's Mail.app.

from appscript import *

def makemessage(addresses, subject, content, showwindow=False):
    """Make an outgoing message in Mail.
        addresses : list of unicode -- a list of email addresses
        subject : unicode -- the message subject
        content : unicode -- the message content
        showwindow : Boolean -- show message window in Mail
        Result : reference -- reference to the new outgoing message
   	"""
    mail = app('Mail')
    msg = mail.make(
            new=k.outgoing_message, 
            with_properties={k.visible: showwindow})
    for anaddress in addresses:
        msg.to_recipients.end.make(
                new=k.recipient, 
                with_properties={k.address: anaddress})
    msg.subject.set(subject)
    msg.content.set(content)
    return msg


# test
print(makemessage(['joe@example.com', 'jane@example.net'],
        'Hello World', 'Some body text.', True))