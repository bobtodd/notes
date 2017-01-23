# Notes for Converting DjVu Files to PDF Preserving Bookmarks

Essentially I'm trying to follow the procedure outlined in the [`dpsprep` repo](https://github.com/kcroker/dpsprep) on GitHub, which itself is mostly a distillation of [this StackExchange thread](http://superuser.com/questions/801893/converting-djvu-to-pdf-and-preserving-table-of-contents-how-is-it-possible), with some additional features mentioned in [this Ubuntu thread](http://askubuntu.com/questions/46233/converting-djvu-to-pdf).  Unfortunately the repo itself doesn't have a list of dependencies, so this amounts to tracing my way through the threads linked in the [README](https://github.com/kcroker/dpsprep/blob/master/README.md) file.  To make life a little easier, here's the short list of the dependencies:

* [`pdfbeads`](https://rubygems.org/gems/pdfbeads), a Ruby gem, which itself depends on
	* [ImageMagick](http://www.imagemagick.org/script/index.php),
	* `rmagic`,
	* `nokogiri`,
	* `pdf-reader`,
	* `iconv`;
* Two Python packages, based on Python 2.x:
	* [`ocrodjvu`](http://jwilk.net/software/ocrodjvu),
	* [`sexpdata`](https://pypi.python.org/pypi/sexpdata);
* [DjVuLibre](http://djvu.sourceforge.net/);
* [PDFtk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/).

These all require varying degrees of pain to install.  The last one, [PDFtk, the PDF toolkit](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/), seems to be the worst.  It takes some special magic to get Homebrew to install it, and it seems that with the new upgrade to Mac OS 10.11 El Capitan, even this installation is broken.  I know... hard to believe, right?  I'll let you discover the mysteries of this adventure below.

## Getting Ready

First we need to make sure we have the repository and all the dependencies installed.  Some of these are based on Ruby, others on Python, and still others on independent libraries the DjVuLibre collection of command-line tools and PDFtk.

### The Repo

Now let's go to a working directory and clone the GitHub repo.

```
> cd path/to/where/the/coverter/tool/will/reside
> git clone https://github.com/kcroker/dpsprep.git
```

Done.


### Ruby

At the moment I'm using [Ruby Version Manager (RVM)](https://rvm.io/), a fantastic tool.  A possible alternative is Rbenv, but I'll stick with my ol' standby for now, since I have no project-based compelling reason to switch at the moment (I currently create gemsets based on "themes" for exploratory computing, rather than tying them to specific projects, which might be better served by the `rbenv`-`bundler` combination).

If you don't have RVM installed on your machine, there's a nice guide [here](http://usabilityetc.com/articles/ruby-on-mac-os-x-with-rvm/), which will of course shunt you off to the official page [here](https://rvm.io/rvm/install).  The new trick is that there is a public key which needs to be installed, and to do this we need the [GNU Privacy Guard](https://en.wikipedia.org/wiki/GNU_Privacy_Guard).  The command `gpg` will create a directory `~/.gnupg` if you don't already have one, and the RVM installation will create `~/.rvm`.  Try the following:

```
> brew install gnupg
> gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3    # or the most up-to-date command on the RVM install page
> \curl -sSL https://get.rvm.io | bash -s stable --ruby    # for the latest stable version
```

Once you have RVM installed, you might need to do a little upgrading.

```
> rvm get stable    # get newest RVM release
> rvm gemset list    # see if I have any gemsets that already serve my purposes
> rvm list known    # find out what rubies are out there
> rvm list rubies    # find out what rubies are on my system
> rvm upgrade 2.1.1 2.2    # ... or upgrade to whatever version you want
> rvm --default use 2.2.1    # make this my default ruby
> ruby -v    # sanity check to see if the right version is my default
```

Now that my Ruby installation is set, it looks like I'll need to install the gem [`pdfbeads`](https://rubygems.org/gems/pdfbeads), which requires `nokogiri >= 1.5.10, pdf-reader >= 1.0.0, rmagick >= 2.13.0`.  So let's create a gemset for doing our conversion and install this gem.

Ah, but first: it seems `pdfbeads` requires [ImageMagick](http://www.imagemagick.org/script/index.php).  So we should install that via Homebrew.

```
> brew install imagemagick    # also installs xz, libpng, libtool, jpeg, libtiff, freetype
```

And make sure the Xcode Command Line Tools are installed (`nokogiri` is a real stickler about this).

```
> xcode-select --install
```

**Update (2017/01/22):** it seems `rmagick` is important for this whole process, but currently something is broken in the new ImageMagick (version 7) install that `rmagick` can't overcome.  See [this thread](http://stackoverflow.com/questions/39494672/rmagick-installation-cant-find-magickwand-h).  It seems like the temporary solution is to downgrade to version 6:

```
> brew install imagemagick@6
> brew link --overwrite --force imagemagick@6
```

Now we can try for `pdfbeads`.

```
> rvm gemset create djvu2pdf
> rvm gemset use djvu2pdf
> gem install pdfbeads    # also installs rmagick, mini_portile, nokogiri, Ascii85, ruby-rc4, hashery, ttfunk, afm, pdf-reader
```

Unfortunately what is not mentioned in the the sources for this procedure: `pdfbeads` relies on `iconv` (a source of much gnashing of teeth years ago).  See [this thread](http://stackoverflow.com/questions/29201518/in-require-cannot-load-such-file-iconv-loaderror).  So it looks like we need to add the following gem.

```
> gem install iconv
```


### Python

It seems we need some tools written as Python packages.  One is called [`ocrodjvu`](http://jwilk.net/software/ocrodjvu).  Another is the [`sexpdata`](https://pypi.python.org/pypi/sexpdata) package.  So we need to get Python in order.

It seems that the GitHub repo [`dpsprep`](https://github.com/kcroker/dpsprep) I'm trying to work with is based on Python 2, so we'll have to make sure we create virtual environments based on that and install the packages compiled against that version of Python.

Let's start with housecleaning for Homebrew's Pythons.

```
> brew upgrade python    # right now, this gives python 2.7.10_2
> pip install --upgrade pip setuptools
> brew upgrade python3    # this currently yields python3 3.5.0
> pip3 install --upgrade pip setuptools
```

It might seem like that's unnecessary, since that's system-wide.  But when I tried to create the virtual environment `djvu2pdf` below, I initially got the error `Could not find a version that satisfies the requirement wheel (from versions: )
No matching distribution found for wheel`.  The above seems to remove that error.  So now we proceed:

```
> pyenv virtualenv 2.7.6 djvu2pdf
> pyenv activate djvu2pdf
> pip install --upgrade setuptools
> pip install --upgrade pip
> pip install ocrodjvu
> pip install lxml    # a dependency for ocrodjvu evidently overlooked by pip
> pip install cython # a dependency for python-djvulibre overlooked by pip
> pip install python-djvulibre # another package for ocrodjvu that pip skips
> pip install sexpdata
```

Note that the package manager `pip` evidently isn't so slick at managing packages.  There are several dependencies it doesn't compile before installing the desired package.  Look at [this thread](https://github.com/h5py/h5py/issues/535) for similar issues.  It seems this might be fixed in later versions of `pip`, but our hand is forced by the requirement for Python 2.x.

Remember that to get out of this virtual environment, you write `pyenv deactivate`.

Wow, that seems to have worked.


### DjVuLibre

DjVuLibre is a pretty robust collection of routines for working with DjVu files.  Best of all, it can be installed by [Homebrew](http://brewformulas.org/Djvulibre).  So we'll go that route.

```
> brew doctor    # figure out where your Homebrew install is at
> sudo chown -R `whoami` /usr/local    # if you happen to get chastized for permissions issues by the doctor
> brew update    # get up to date
> brew doctor    # go back for a second opinion
> brew install djvulibre    # also installs libtiff dependency
```

I initially thought we might also need some other tools, like [Okular](https://okular.kde.org/), [Evince](https://wiki.gnome.org/Apps/Evince), which can be installed via Homebrew (`brew install okular evince`), but it seems that's not necessary.


### PDFtk

There's an additional library called [PDFtk, the PDF toolkit](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) whose name, I assume, is fairly descriptive of what it does.  We need to install that.

```
> brew install pdftk
```

Well, that would work, except that it seems PDFtk is lame.  See [this thread](https://github.com/caskroom/homebrew-cask/issues/7707), followed by [this one](https://github.com/caskroom/homebrew-cask/pull/11351).  There seems to be a possible solution suggested in the first thread... but I think I've found a different (better?) way.

Perhaps the [`homebrew-pdftk` repo](https://github.com/docmunch/homebrew-pdftk) on GitHub will work.  We'll try their sequence of commands.

```
> brew tap docmunch/pdftk
> brew install pdftk    # installs dependencies ecj, gcc (compiled with --with-all-languages flag)
```

This is a valid procedure, but it seems that it hangs when finally trying to install `pdftk` after all the dependencies.  The thread ["Installation hangs on El Capitan"](https://github.com/docmunch/homebrew-pdftk/issues/7) suggests this is not a problem isolated to my machine.  Unfortunately it looks like there's no solution to the problem as of yet.  Figures.

Update (2015/11/04): It seems like there might be hope.  There's a GitHub Gist [*Installing PDFtk Server edition on your Mac*](https://gist.github.com/jvenator/9672772a631c117da151) that shows how to install PDFtk in a way that avoids it rewriting many of the permissions in `/usr/local/`... something it shouldn't have been doing in the first place, since that tends to break things for other programs installed there.  However it turns out that even this method broke with the advent of Mac OS 10.11.  However `@rmehner` left a Gist [*Install PDFtk without touching up the permissions*](https://gist.github.com/rmehner/fed9d1ac70eaa296306a), which runs as a shell script and should work on OS 10.11.  I'll leave a local copy of it [here](./extra/install_pdftk.sh).  So let's give it a shot.

```
> install_pdftk.sh https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.11-setup.pkg
> brew doctor
```


## Getting On With It

Now we're ready to start.  Finally.

Let's put the original `djvu` file in a test directory.  Then let's try

```
> cd path/to/test/
> rvm gemset use djvu2pdf    # do this before using pyenv, otherwise rvm will get confused by the changed path
> pyenv activate djvu2pdf
> ../path/to/dpsprep test_file.djvu test_file.pdf
```

Success!  For now...