#!/bin/sh

echo "Installing osadict..."

cd `dirname "$0"`

sudo cp osadict /usr/local/bin
sudo chmod 755 /usr/local/bin/osadict

echo "osadict is installed."
