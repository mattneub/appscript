#!/usr/bin/env pythonw

"""EmailURL - Emails a URL from Safari to user's friends.

(c) 2004 HAS

This script composes an email containing a short, user-specified message plus
the URL of the webpage currently being viewed in Safari's front window. This
is then sent to the home email address of every person in a group named
'Friends' in user's Address Book. (Note: anyone without a home email address
is ignored.) Uses Mail to compose and send the message.
"""

import EasyDialogs
from appscript import *

#######

def infoForBrowserWindow(idx):
    """Get name and URL of a Safari window. (Raises a RuntimeError if window 
            doesn't exist or is empty.)
        idx : integer -- index of window (1 = front)
        Result : tuple -- a tuple of two unicode strings: (name, url)
    """
    window = app('Safari').windows[idx]
    if not window.exists():
        raise RuntimeError, "Window %r doesn't exist." % idx
    else:
        pageName = window.name.get()
        pageURL = window.document.URL.get()
    if not pageURL: raise RuntimeError, "Window %r is empty." % idx
    return pageName, pageURL


def getFriendsEmails():
    """Get Home email addresses for people in an Address Book group named 
            'Friends'.
        Result: list of tuple -- list of tuples of form: 
                (name, home email address)
    """
    result = []
    for person in app('Address Book').groups['Friends'].people.get():
        homeEmails = person.emails[its.label == 'Home'].get()
        if homeEmails:
            result.append((person.name.get(), homeEmails[0].value.get()))
    return result

##

def composeMessageBody(pageURL):
    """Compose email's content."""
    extraText = EasyDialogs.AskString('Your message:', '')
    if extraText == None:
        raise RuntimeError, 'User cancelled.'
    return extraText + '\n\n<%s>' % pageURL

##

def makeMessage(addresses, subject, content, showWindow=False):
    """Make an outgoing message in Mail.
        addresses : list of tuple -- a list of tuples of form: 
                (name, email address)
        subject : unicode -- the message subject
        content : unicode -- the message content
        showWindow : Boolean -- show message window in Mail
        Result : reference -- reference to the new outgoing message
   	"""
    mail = app('Mail')
    msg = mail.make(
            new=k.outgoing_message, 
            with_properties={k.visible: showWindow})
    for address in addresses:
        msg.to_recipients.end.make(
                new=k.recipient, 
                with_properties={k.name: address[0], k.address: address[1]})
    msg.subject.set(subject)
    msg.content.set(content)
    return msg


def sendEmail(addresses, subject, content):
    """Create and send an email from Mail.
        addresses : list of string
        subject : string
        content : string
    """
    makeMessage(addresses, subject, content).send()

#######
# MAIN

try:
    pageName, pageURL = infoForBrowserWindow(1)
    content = composeMessageBody(pageURL)
    sendEmail(getFriendsEmails(), 'Link: "%s"' % pageName, content)
    EasyDialogs.Message('Message has been sent.')
except Exception, err:
    EasyDialogs.Message("Couldn't email URL due to %r: %r" % (
            err.__name__, err.args))