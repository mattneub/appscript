#!/bin/sh

echo "Installing osascangui..."

cd `dirname "$0"`

sudo cp osascangui /usr/local/bin
sudo chmod 755 /usr/local/bin/osascangui

echo "osascangui is installed."
