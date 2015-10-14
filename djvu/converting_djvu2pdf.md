# Notes for Converting DjVu Files to PDF Preserving Bookmarks

Essentially I'm trying to follow the procedure outlined in the [`dpsprep` repo](https://github.com/kcroker/dpsprep) on GitHub, which itself is mostly a distillation of [this StackExchange thread](http://superuser.com/questions/801893/converting-djvu-to-pdf-and-preserving-table-of-contents-how-is-it-possible), with some additional features mention in [this Ubuntu thread](http://askubuntu.com/questions/46233/converting-djvu-to-pdf).

## Getting Ready

First we need to make sure we have all the dependencies installed.  Some of these are based on Ruby, others on the DjVuLibre collection of command-line tools.

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

Well, that would work, except that it seems PDFtk is lame.  See [this thread](https://github.com/caskroom/homebrew-cask/issues/7707), followed by [this one](https://github.com/caskroom/homebrew-cask/pull/11351).  There seems to be a possible solution suggested in the first thread...


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
> pip install sexpdata
```

Remember that to get out of this virtual environment, you write `pyenv deactivate`.

Wow, that seems to have worked.

### The Repo

Now let's go to a working directory and clone the GitHub repo.

```
> cd path/to/where/the/coverter/tool/will/reside
> git clone https://github.com/kcroker/dpsprep.git
```

Done.

## Getting On With It

Now we're ready to start.  Finally.

Let's put the original `djvu` file in a test directory.  Then let's try

```
> cd path/to/test/
> rvm gemset use djvu2pdf    # do this before using pyenv, otherwise rvm will get confused by the changed path
> pyenv activate djvu2pdf
> ../path/to/dpsprep test_file.djvu test_file.pdf
```