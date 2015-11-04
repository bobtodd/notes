#!/usr/bin/env bash

# This is based on this excellent gist https://gist.github.com/jvenator/9672772a631c117da151
# Nothing of this is my original work, except that I made the download link an argument
# to this script, so it installs on OSX 10.11
#
# Thank you jvenator & sethetter
set -e

error() { info "$1"; exit 1; }
have() { command -v "$1" >/dev/null; }
usage() { echo "usage: $0 LINK_TO_SETUP_PKG"; }

have "brew" || error "Need homebrew to be installed"
[[ "$1" ]] || { usage; exit 1; }
[[ "$1" == "--help" || "$1" == "-h" ]] && { usage; exit; }

 # remove old versions
rm -Rf ~/Downloads/pdftk_download.pkg
rm -Rf ~/Downloads/pdftk_package
rm -Rf /usr/local/Cellar/pdftk

# Download and extract the Mac OS X server install package
# OSX <10.11: https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.6-setup.pkg
# OSX 10.11: https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.11-setup.pkg
curl -o ~/Downloads/pdftk_download.pkg $1
pkgutil --expand ~/Downloads/pdftk_download.pkg ~/Downloads/pdftk_package
cd ~ && mkdir /usr/local/Cellar/pdftk /usr/local/Cellar/pdftk/2.02 /usr/local/Cellar/pdftk/2.02/bin /usr/local/Cellar/pdftk/2.02/lib /usr/local/Cellar/pdftk/2.02/share /usr/local/Cellar/pdftk/2.02/share/man /usr/local/Cellar/pdftk/2.02/share/man/man1

# Give the Payload file the proper gzip file extension and unzip it
mv ~/Downloads/pdftk_package/pdftk.pkg/Payload ~/Downloads/pdftk_package/pdftk.pkg/payload.gz
gunzip ~/Downloads/pdftk_package/pdftk.pkg/payload.gz

# Use cpio to unarchive the resulting file
cd ~/Downloads/pdftk_package/pdftk.pkg/ && cpio -iv < ~/Downloads/pdftk_package/pdftk.pkg/payload && cd ~

# Move the relevant extracted files to their appropriate locations within the Cellar/pdftk directory
cd ~ && mv Downloads/pdftk_package/pdftk.pkg/bin/pdftk /usr/local/Cellar/pdftk/2.02/bin/pdftk && mv Downloads/pdftk_package/pdftk.pkg/lib/* /usr/local/Cellar/pdftk/2.02/lib/ && mv Downloads/pdftk_package/pdftk.pkg/man/pdftk.1 /usr/local/Cellar/pdftk/2.02/share/man/man1/pdftk.1

# link
brew link pdftk

echo "Done. You might wanna run 'brew doctor' to make sure everything is fine with your brew install"
