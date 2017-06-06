#!/usr/bin/env bash

PYGLOSSARY_HOME=~/BtWk/Extras/pyglossary/

usage="Convert Lingvo DSL source to AppleDict\n
USAGE:\n
=====\n
\t${0##*/} <dictionary.dsl|dictionary.dsl.dz> \n

\n
Assumptions:\n
===========
\n
 - pyglossary is located in ~/projects/pyglossary/pyglossary/pyglossary.pyw (edit this script to modify the value)\n
 - DSL input file is UTF-16\n
 - .dsl and .dsl.dz files are accepted\n
\n
Dependencies:\n
============\n
 - PyGlossary from https://github.com/ilius/pyglossary\n
\tget it from git:\n
\t\tgit clone https://github.com/ilius/pyglossary.git\n
 - Command Line Tools for Xcode http://developer.apple.com/downloads\n
 - Dictionary Development Kit as part of Auxillary Tools for Xcode <http://developer.apple.com/downloads>_. Extract to /Developer/Extras/Dictionary Development Kit\n
\n
 - dictzip, if you need to work with compressed .dz files\n
 \n
Also see the pyglossary readme file:\n
     https://github.com/ilius/pyglossary/blob/master/README.rst

Added notes (TBK):
  1. Make sure you have installed the Dictionary Development Kit, as mentioned above
  1. if *.dsl file is zipped, first unzip, then descend into the directory
	 "

if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$#" != "1" ] ; then
	echo -e $usage
	exit ;
fi


utf16dsl="$1"
is_dictzip=false

if [[ "${utf16dsl}" == *.dz ]] ; then

	is_dictzip=true
	echo File is compressed! Uncompressing...
	dictzip -k -v -d "$utf16dsl"
	utf16dsl=${utf16dsl%.dz}
fi

utf8dsl="${utf16dsl%.dsl}_utf8.dsl"

echo utf8dsl= "$utf8dsl"
#read -p "dbg"
echo converting "$utf16dsl" to "$utf8dsl"...
iconv -f UTF-16 -t UTF-8 "$utf16dsl" > "$utf8dsl"

echo conversion to UTF-8 done!
echo converting "$utf8dsl" to AppleDictFormat

python "$PYGLOSSARY_HOME/pyglossary.pyw" --read-format=ABBYYLingvoDSL --write-format=AppleDict "$utf8dsl" "${utf8dsl%.dsl}.xml"
#python /Users/vio/projects/pyglossary/pyglossary/pyglossary.pyw --read-format=ABBYYLingvoDSL --write-format=AppleDict $1 $2

echo Running make ...

make

echo running make install...

make install

read -p "run make clean? (press CTR+c to cancel)"
echo cleaning up

make clean

#remove unpacked .dz file if exists
if [ $is_dictzip == true ] ; then

	read -p "Remove generated files?"

	echo deleting generated files...

	rm "$utf8dsl"
	rm "${utf8dsl%.dsl}.xml"
	rm "${utf8dsl%.dsl}.plist"
	rm "${utf8dsl%.dsl}.css"
	echo removing unpacked .dz file...
	rm "$utf16dsl"
fi

echo All Finished!
