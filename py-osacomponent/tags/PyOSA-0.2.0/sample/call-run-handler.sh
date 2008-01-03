#!/bin/sh

# compile script and call its run handler with arguments

osascript -l PyOSA -e 'def run(args=[]): return "RESULT: %r" % args' hello world
