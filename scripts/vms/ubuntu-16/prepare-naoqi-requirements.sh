#!/bin/bash

sudo apt update

sudo apt install --yes python

echo "Downloading pip for Python 2.7"
wget 'https://bootstrap.pypa.io/pip/2.7/get-pip.py'

echo "Installing pip for Python 2.7"
python2 get-pip.py
