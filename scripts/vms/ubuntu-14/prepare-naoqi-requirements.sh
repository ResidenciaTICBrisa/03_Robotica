#!/bin/bash

sudo apt-get update

echo "Installing GCC and G++"
sudo apt-get install --yes build-essential

echo "Installing Python 2 Build dependencies"
sudo apt-get build-dep --yes python-all-dev
sudo apt-get install --yes python-all-dev pkg-config \
	libbz2-dev libffi-dev libgdbm-dev liblzma-dev \
	libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
	lzma lzma-dev tk-dev uuid-dev zlib1g-dev

echo "Downloading Python 2.7.11"
wget 'https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tar.xz'

echo "Extracting Python 2.7.11"
tar -xvf 'Python-2.7.11.tar.xz'

echo "Compiling and installing Python 2.7.11"
cd 'Python-2.7.11'
./configure --prefix "${HOME}/.local"
make -j "$(nproc)" profile-opt
make install

echo "Downloading pip for Python 2.7"
wget 'https://bootstrap.pypa.io/pip/2.7/get-pip.py'

echo "Installing pip for Python 2.7"
"${HOME}/.local/bin/python" get-pip.py
