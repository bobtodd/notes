# Converting Lingvo Dictionaries to the Dictionary.app Format

So I've been trying to convert some Icelandic dictionaries for use with the Mac OS X Dictionary.app.  The process is far more involved than it should be, but at least the work has been made a little easier with the `pyglossary` package.  So let me take you through the steps for conversion.

## Download the Lingvo Dictionaries

First off, you'll need the raw dictionary you want to start with.  I've never used [Lingvo dictionaries](http://www.abbyy.com/lingvo_dictionary/), but evidently it's a dictionary format that lots of people get a lot of mileage out of, so you have to know it's out there.

The particular dictionaries I happened to be interested in were on Icelandic, listed at [this page](http://norse.ulver.com/files/lingvo/index.html).  In particular, I wanted to convert [Zoëga's *Concise Dictionary of Old Icelandic*](http://norse.ulver.com/files/lingvo/zoega.dsl.zip) and [Cleasby & Vígfússon's *Icelandic-English Dictionary*](http://norse.ulver.com/files/lingvo/cleasby.dsl.zip).  These are both old and out of copyright, so as I understand there's no harm in placing the links here.

So let's work on Zoëga's dictionary, and the other is similar.  Downloading gets you a file `zoega.dsl.zip`.  Unzip that file into a directory `zoega.dsl/`.  Descend into that directory within Terminal: that's where we're going to be doing our work.

But first we need to get our system set up.

## Python Setup

Personally, I like to set up Python using Homebrew, with the Pyenv virtual environment manager to allow convenient switching between versions of Python (which you'll need to do for this little job if you're typically developing in Python 3).  See my notes [here](https://github.com/bobtodd/notes/blob/master/homebrew/python.md) for how to set this system up on the Mac.  If you like to use [IPython](http://ipython.org/), things can get a little hairy.  But it's worth it.

OK, so we'll assume you have a working installation of Python.  In particular, you'll need a version Python 2.x.  Let's create a virtual environment running that (let's assume that our Python version is 2.7.6):

```
> pyenv virtualenv 2.7.6 glossary
> pyenv virtualenvs
> pyenv activate glossary
```

That creates a virtual environment called `glossary` running Python 2.7.6, then lists all the virtual environments you have, and finally activates the `glossary` environment.  We'll work in that environment.

We need to install a couple of packages.  We'll use `pip`:

```
> pip install beautifulsoup4
> pip install html5lib
> pip install six
> pip install wsgiref
```

I forget if some of those are installed automatically as dependencies for BeautifulSoup4.  That's the one we're really after.

## Xcode Setup

We also need to use Mac-specific tools, understandably, as we're trying to create a dictionary for that platform.  So unsurprisingly, we'll need Xcode.  You can download that [here](http://developer.apple.com/downloads).  You'll need an Apple ID to download Xcode.  In particular, you need to install the Command Line Tools.  The instructions for installing them are pretty straightforward as part of Xcode installation.  But the step that might not be clear is the following:

* You'll need to actually *open* Xcode and follow the screen prompt to finish installing the tools.

There's also a way of doing this in Terminal without opening Xcode.  Perhaps it's this:

```
> xcode-select --install
```

But honestly I've never done it that way.

## Dictionary Development Kit Setup

The Dictionary Development Kit used to be part of Xcode, but now it seems it has been split off.  Moreover, it used to be installed automatically in the `Developer/` directory at root level.  But recent changes to Mac OS X (as of Yosemite, or perhaps even Mavericks) mean that there is no such directory at root level.  So we're going to create one.

First, download the Dictionary Development Kit as part of the Auxillary Tools for Xcode [here](http://developer.apple.com/downloads).  Then create the following directories:

```
> mkdir /Developer
> mkdir /Developer/Extras
```

Copy the contents of the Dictionary Development Kit to this last directory: `/Developer/Extras/`.  The tools you now need will be in `/Developer/Extras/Dictionary\ Development\ Kit/`.

## Pyglossary Setup

Now back to our Python setup.  The major tool we're going to employ is [PyGlossary](https://github.com/ilius/pyglossary), a really fantastic tool (thank you, [ilius](https://github.com/ilius)!).  Create a work directory in your home directory, and clone the PyGlossary repository there:

```
> mkdir ~/Work/
> cd ~/Work
> git clone https://github.com/ilius/pyglossary.git
```

## The Final Element: a Gist

There's one last tool that makes things work a lot more quickly.  (We could do everything by hand with what we've done above.)  That tool is this [gist](https://gist.github.com/elFua/8540294) submitted by [elFua](https://github.com/elFua).  I've modified it only slightly and placed it [here](./convert_dsl_to_appledict.sh).  This gist is actually a shell script that does all the processing for us.

What you'll need to do is edit the very beginning of the script for your `PYGLOSSARY_HOME`.  I've set that variable to my clone of the PyGlossary repo inside my work directory, called `BtWk/`.  You'll need to adjust this to your work directory containing the PyGlossary clone.

Now you should be ready to go.

## Let's *Do* This!

Alright, so let's say you have the `zoega.dsl` directory on your Desktop, containing the file `ZoegaIsEn.dsl`.  Then we'll go through the following procedure:

```
> cd ~/Desktop/zoega.dsl
> pyenv activate glossary
> /path/to/convert_dsl_to_appledict.sh ZoegaIsEn.dsl
> pyenv deactivate glossary
```

That will run the script on Zoëga's dictionary.  The script invokes `make`, and it will then prompt you asking if you want it to clean up after it's done.  Answer that, and you're done.

My output looks like this:

```
08:41 AM lrcbt:~> cd Desktop/
08:41 AM lrcbt:Desktop> pyenv activate glossary 
(glossary)08:41 AM lrcbt:Desktop> pip freeze
beautifulsoup4==4.3.2
html5lib==0.999
six==1.9.0
wsgiref==0.1.2
(glossary)08:41 AM lrcbt:Desktop> cd zoega.dsl
(glossary)08:41 AM lrcbt:zoega.dsl> ../../Public/Box\ Sync/Etc/scripts/convert_dsl_to_appledict.sh ZoegaIsEn.dsl 
utf8dsl= ZoegaIsEn_utf8.dsl
converting ZoegaIsEn.dsl to ZoegaIsEn_utf8.dsl...
conversion to UTF-8 done!
converting ZoegaIsEn_utf8.dsl to AppleDictFormat
LZO compression support is not available
Reading file "ZoegaIsEn_utf8.dsl"
Writing to file "ZoegaIsEn_utf8.xml"
filename=ZoegaIsEn_utf8.xml
Writing: |████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████|100.0% Time: 00:00:52

done
Running make ...
"""/Developer/Extras/Dictionary Development Kit"/bin"/build_dict.sh"  "ZoegaIsEn_utf8" "ZoegaIsEn_utf8.xml" "ZoegaIsEn_utf8.css" "ZoegaIsEn_utf8.plist"
- Building ZoegaIsEn_utf8.dictionary.
- Cleaning objects directory.
- Preparing dictionary template.
- Preprocessing dictionary sources.
- Extracting index data.
- Preparing dictionary bundle.
- Adding body data.
- Preparing index data.
- Building key_text index.
- Building reference index.
* Note: No reference index record.
- Fixing dictionary property.
- Copying CSS.
- Finished building ./objects/ZoegaIsEn_utf8.dictionary.
echo "Done."
Done.
running make install...
echo "Installing into ~/Library/Dictionaries".
Installing into ~/Library/Dictionaries.
mkdir -p ~/Library/Dictionaries
ditto --noextattr --norsrc ./objects/"ZoegaIsEn_utf8".dictionary  ~/Library/Dictionaries/"ZoegaIsEn_utf8".dictionary
touch ~/Library/Dictionaries
echo "Done."
Done.
echo "To test the new dictionary, try Dictionary.app."
To test the new dictionary, try Dictionary.app.
run make clean? (press CTR+c to cancel)yes
cleaning up
/bin/rm -rf ./objects
All Finished!
(glossary)08:43 AM lrcbt:zoega.dsl> 
```

If you now open the Mac Dictionary.app, go to Preferences and look at your dictionaries.  You should see a listing for "Zoëga's Old Icelandic Dictionary (Is-En)".  That's the one you want.

## Addendum: Dictionary Naming

If you're like me, you've got a lot of dictionaries that you need to switch among.  This leads to a competition for space on the menu bar of the Dictionary.app.  So you need to be able to name the dictionaries meaningfully.  [This blog post](https://davidtse916.wordpress.com/2008/01/24/adding-dictionaries-to-the-built-in-dictionary-application-in-leopard/) provides a nice explanation of how to go about it.  The majority of the post is about using the DictUnifier app to create a dictionary, which we've already done.  But at the end it tells you how to edit the name of the dictionary you've created.

First, we want to go to the folder where our new dictionary is stored.  The script we used (as I've edited it) places the dictionary in the user's `Library/` and adds the suffix `_utf8` before the `.dictionary` extension.  So our file is the following:

```
~/Library/Dictionaries/ZoegaIsEn_utf8.dictionary
```

This `.dictionary` file is actually a folder.  So you can right-click (or two-finger tap) on that and select "Show Package Contents".  This will open a folder called `Contents/` where you'll see a file `Info.plist`.  Double click on that plist file.  On my system this opens within Xcode.

Let's edit the "Bundle display name".  This is what appears in the Dictionary.app's list of dictionaries when you select "All".  Let's give the proper title of the dictionary: "Zoëga's Concise Dictionary of Old Icelandic".

Now let's edit the "Bundle name".  This is what appears on the toolbar within the Dictionary.app, where there's the heavy competition for space.  Let's simply give it the name "Zoëga", since we all know what that represents.

Now save the edits.  Open up the Dictionary.app.  When you select "All" in the menu bar, you should see a listing (assuming you've selected the dictionary in the Preferences pane) for *Zoëga's Concise Dictionary of Old Icelandic*.  And on your toolbar you should simply see "Zoëga".

Done.

## Follow-Up: Pali Dictionaries

So now that we've had some success with the Old Icelandic dictionaries, it's time to try our hand at Pali dictionaries.  I first tried Buddhadatta's *Pali-English-Pali* dictionary, available [here](https://github.com/sanskrit-coders/stardict-pali/blob/master/en-head/tars/pali-en-pa.tar.gz).

After unzipping the file, we have a directory `stardict-pali-en-pa-2.4.2`.  Let's descend into the directory and use some `pyglossary` magic:

```
> pyenv activate glossary
> cd stardict-pali-en-pa-2.4.2
> ${PYGLOSSARY_HOME}/pyglossary.pyw --write-format=AppleDict pali-en-pa.ifo pali-en-pa.xml
> make
> make install
```

Then we can go edit the dictionary's `Info.plist`.  For the "Bundle display name" we'll write "Buddhadatta's Pali-English English-Pali Dictionary".  And for the "Bundle name" we'll write "Bdta P-E-P".

Now we'll see if we can pull off the same trick with the Pali Text Society's *Pali-English Dictionary*, available [here](https://github.com/sanskrit-coders/stardict-pali/blob/master/en-head/tars/pts_pali.tar.gz).  Unzipping the file leaves us with a directory `pts_pali`.  So we follow a similar procedure

```
> pyenv activate glossary
> cd pts_pali
> ${PYGLOSSARY_HOME}/pyglossary.pyw --write-format=AppleDict pts_pali.ifo pts_pali.xml
> make
> make install
```

For the "Bundle display name" we can write "Pali Text Society's Pāli-English Dictionary", and for the "Bundle name" we can put "PED".

Finally!  I've finally got the PTS's *PED* in the Mac Dictionary.app!