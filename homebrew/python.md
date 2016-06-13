Python Installation with Homebrew
=================================

I'm going to try to take what should be a simple, no-nonsense approach.  I've worked with [Python][python] via [Homebrew][brew] for quite some time, but managing the versions can get tricky.  [Virtualenv][venv], and in particular [Virtualenvwrapper][venvw], have been pretty helpful.  But there always comes a point where this little triumvirate grinds to a halt.  For example, I installed both Python 2.x and Python 3.x via Homebrew, and then compiled Virtualenv and Virtualenvwrapper under Python 3.x.  Evidently this was, specifically, Python 3.3.  And so when I naively upgraded Python on my system by doing `brew upgrade python` and `brew upgrade python3`, Virtualenvwrapper stopped working.  After much gnashing of teeth, it turned out that I didn't read the fine print: "virtualenvwrapper is tested under Python 2.6 - 3.3." ([Virtualenvwrapper Overview][venvwo]).  Evidently it only works where it's been tested.  That's fair enough: programming is hard, and testing is worse.  I'm thankful that somebody took the time to develop Virtualenvwrapper and didn't leave the task to me.  But the underlying *hope* of package managers is that one shouldn't *need* to read the fine print (even though that certainly will never be true in all cases, even for the best package manager).

So this time I'm going to try to install my Pythons via [Pyenv][pyenv].  And to manage the various environments, e.g. the various packages I want to use in a version-specific or project-specific way, I'll try using [Pyenv-Virtualenv][pyenvv].  Its interface seems to be based on [Ruby Version Manager (RVM)][rvm], which makes me happy.  See [this slide presentation][pyenv-slide] for some details.  Let's see how it goes.



Homebrew Python Installation: Sans Pyenv
----------------------------------------

This section is for installing default versions of Python using Homebrew.  This is useful if I'm not going to employ [Pyenv][pyenv].  But I just noticed that Pyenv has a variable command `global` which allows one to set a **default** version of Python, obviating the need for separate installations as outlined in the remainder of this section.  So, **if you're going to use (only) [Pyenv][pyenv], skip to the next section!**

But the rest of this section **is** useful if you plan to install [IPython][ipython].  In particular, to use the Qt Console in IPython, you need to install Qt, which is most easily accomplished with Homebrew.  To connect the two, `PyQt` is necessary, which Homebrew can also install.  But it wants to compile it *with its own Python*.  So it's a good idea to install Homebrew's Python(s) as well, even outside of Pyenv's Pythons.

I've backed out of all my Homebrew-installed Pythons (`brew uninstall python` and `brew uninstall python3`), so that I only have the system-installed Python `/usr/bin/python`.  I *don't* want to use that Python myself -- *ever* (-ish) -- since that will be outdated quickly, and it will be tedious to upgrade.  So I *do* want a Homebrew-installed Python for low-cal Python hacking.  I'll install Python 2.x, just so that overrides the system Python.  Because of [Pip version errors][pip-v], it seems best to **build from source**.

    brew install python --build-from-source

Next, based on other [Pip installation errors][pip-i1] and comments [here][pip-i2], we no longer seem to need to upgrade the Distribute package; upgrading Setuptools is enough.  We follow that with an upgrade to Pip itself.

    pip install --upgrade setuptools
    pip install --upgrade pip

Incidentally, the system also has older Python 3s installed.  So it's probably simpler to install the Homebrew version to override those.

    brew install python3 --build-from-source
    pip3 install --upgrade setuptools
    pip3 install --upgrade pip

That's just so that I can keep the system current and not have to mess around with the various Frameworks varieties of Python installed on the system.  (Perhaps these can be removed once I figure out how to set a default Python via [Pyenv][pyenv]... ah, it can be done with the `global` command.)



Pre-IPython Setup: Qt and the Gnashing of Teeth
-----------------------------------------------

I want to be able to use IPython both via the Qt Console and via Notebooks.  The real problem here has traditionally been compiling Qt on the machine: Homebrew installs Qt compiled against the Homebrew-installed Python.

    pyenv deactivate
    brew install qt --with-python3 --build-from-source
    brew install pyqt --with-python3 --build-from-source
    brew install zeromq

Note that the command `brew install pyqt --with-python3` also installs the dependency `sip`.  Moreover, this command causes Homebrew to install via **both** `python` and `python3`.  The result is that the additional files are placed in `/usr/local/Cellar/pyqt/4.10.4/lib/python2.7/site-packages` and `/usr/local/Cellar/pyqt/4.10.4/lib/python3.4/site-packages`, respectively.

It might also be worth noting that [this issue][qt5-pyqt] mentions that (as of a year ago) PyQt and PySide still do not work with Qt5.  So installing Qt5 is still not an option for working with IPython.

As one additional factor, if we try to install PySide in the `scipy2` virtual environment later (i.e. in an environment running Python 2.x), the PySide build will look for `cmake`.  So we need to install that with Homebrew.

    brew install cmake

This is mentioned in the [Pyside installation instructions][pyside], but only in one section on installing for Mac OS X, and not in a different Mac OS X installation section elsewhere on the same page.  The explanation there doesn't mention anything about why `cmake` is required, nor why it should be installed to follow one installation method but not to follow another method.  Both methods use Homebrew and later `pip`, so nothing is being built by hand in either explanation.

With any luck, that should do it.



Pyenv Installation
------------------

For real hacking, we can work with [Pyenv][pyenv] and get some fine-tuned control over the Pythons we install and the packages installed corresponding either to the various Pythons or to the various projects (with various Pythons).

    brew install pyenv

Homebrew also provides a suggestion for using Homebrew's own directories rather than `~/.pyenv`, which seems like a good idea: we add the line

    #export PYENV_ROOT=/usr/local/opt/pyenv
    # New location:
    export PYENV_ROOT=/usr/local/var/pyenv

to the `~/.bashrc` file.  Then I need to add the line (this must come *after* the preceding line)

    if which pyenv > /dev/null;
      then eval "$(pyenv init -)";
    fi

to my `~/.bashrc` file.  (Beware: the order of the lines `export PYENV_ROOT` and `if which pyenv... fi` is important.  See [this issue report][pyenv-order].)  Then we `source` it.

    source ~/.bashrc

This evidently enables the use of shims that Pyenv is based on, and it allows autocompletion (which is a beautiful thing).  Then we add Pyenv-Virtualenv.

    brew install pyenv-virtualenv

This installation now suggests putting the following in the `~/.bashrc` file:

	if which pyenv-virtualenv-init > /dev/null;
	  then eval "$(pyenv virtualenv-init -)";
	fi

Once again

	source ~/.bashrc

That should do it.

### Note on Permissions

If at this point or some later point in the process you run into a "Permission denied" error, where Homebrew or one of the installed packages doesn't have permission to write to one of the requisite directories of `/usr/local/`, the following command will likely help:

	sudo chown "$USER":admin /usr/local

This will change the current user to the owner of `/usr/local/`, so long as (s)he is part of the administrator group.



Creating Virtual Environments
-----------------------------

It typically turns out that the most useful tools for scientific computation in Python were developed with Python 2.x, and their transfer to Python 3.x is a long and on-going process.  So it'll be useful to have both a Python 2.x and a 3.x installed with Pyenv.

    pyenv install 2.7.6
    pyenv install 3.4.0

(**NB:** I can set Python 3.4 to be the *global* Python, the one that executes whenever I type `python`.

    pyenv global 3.4.0

But that seems to cause a conflict later on when installing `PyQt`.  Installing the latter via Homebrew means that the latter will install `python` -- i.e. Python 2.7.6 -- as a dependency for compilation.  Setting the global Python to something other than the system Python will result in errors.)

But I need the ability to switch between Python 2.x and 3.x in various Scientific Python applications.  So I'll create a virtual environment for each of those.

    pyenv virtualenv 2.7.6 scipy2
    pyenv virtualenv 3.4.0 scipy3
    pyenv virtualenvs

These lines specify the Python version to be used in the newly created virtual environment: 2.7.6 for the environment I'm calling `scipy2`, and 3.4 for the environment I've named `scipy3`.  The last line lists the virtual environments.  To activate and deactivate a given virtual environment, say `scipy3`, I'd type the following.

    pyenv activate scipy3
    pyenv deactivate

Just for reference, [this issue][pyenv-uninstall] illustrates how to remove a virtual environment:

    pyenv uninstall <virtual environment name>

Simple as that.

But [looking ahead][ipy-pyenv], IPython and Pyenv may throw errors if I don't first upgrade the Setuptools in each environment.

    pyenv activate scipy3
    pip install --upgrade setuptools
    pip install --upgrade pip
    
    pyenv activate scipy2
    pip install --upgrade setuptools
    pip install --upgrade pip



Setting Up for Scientific Computation
-------------------------------------

The package NumPy requires the Fortran compiler.  This is most conveniently installed via Homebrew.  This used to be a separate `gfortran` package, but now this has been rolled into `gcc`:

    brew install gcc

This will add the dependencies `gmp, mpfr, libmpc, isl`.

With that installed, I can now go ahead and set up the packages I want for my respective scientific sandboxes.  First I'll set up the sandbox with Python 3.

    pyenv activate scipy3
    pip install nose
    pip install numpy
    pip install scipy
    pip install matplotlib
    pip install pandas

These will also install `python-dateutil`, `tornado`, `pyparsing`, `pytz`, and `six`.  Now for the same with Python 2.

    pyenv activate scipy2
    pip install nose
    pip install numpy
    pip install scipy
    pip install matplotlib
    pip install pandas



Setting up IPython
------------------

Finally we come to the really important part of the installation process: IPython.  I'll tell you right now, IPython must be **pretty stinkin' cool** to warrant all the extra effort of getting this beast running in different virtual environments.  Yes, it's worth it.  But just barely, because the effort:success ratio of installing IPython in different virtual environments running variously Python 2.x and 3.x is frickin' astronomical.  This whole installation procedure would be done in half an hour if I weren't trying to install IPython.  But since I *am* trying to install it, the process drags on for days, during which I try to figure out what needs to be loaded before what, whether to load a particular package via `pip` in a virtual environment or via `brew` outside of all environments, whether general packages (outside of virtual environments) need to be compiled with Homebrew's `python` or `python3` -- or both! -- and so on.  Not even the `git` log file for these notes will show half of the permutations I've tried.  It's frustrating beyond words... thank goodness there's a reward at the end... *if* I can get it working.

### The Python 3.4 Virtual Environment

Let's see what happens when we go back and try to get this to work for Python 3.x.

    pyenv activate scipy3
    pip install pyzmq
    pip install pygments

Typically IPython has problems with the Qt Console.  When we seek to use the command `ipython qtconsole --pylab=inline`, IPython checks whether PyQt4 is installed or whether PySide is installed.  So I'm going to install PySide, just to see if IPython can find *one* of those packages and sort things out itself.  In fact, this would be the preferred way of installing a package telling IPython how to link with Qt, since this installs via `pip`, and it can therefore be keyed separately to Python 2.x or 3.x installations within a virtual environment.  We'll see how it goes.

According to the [PySide installation guide][pyside], we need to run the following commands.
    
    pip install -U PySide
    pyside_postinstall.py -install

*Note: since this was last updated, IPython has now changed its dependencies.  It now requires the following:*

	pip install jsonschema

Then we can finally try installing IPython.
    
    pip install ipython[all]

This will additionally install the following packages: `gnureadline`, `numpydoc`, `Sphinx`, `jinja2`, `docutils`, `markupsafe`.  Now we can finally test out IPython... as always with diminished expectations.
    
    ipython qtconsole --pylab=inline
    ipython notebook --pylab=inline

Crossing my fingers...

**Holy crap!** *It worked!*  Even with the Qt Console!  This, my friends, could be a landmark in Python installation worldwide!

### The Python 2.7.6 Virtual Environment

Now let's see how things work in the `scipy2` virtual environment (remember to run `brew install cmake`, mentioned above, before activating the `scipy2` virtual environment).

    pyenv activate scipy2
    pip install pyzmq
    pip install pygments
    pip install -U PySide
    pyside_postinstall.py -install

Unfortunately, our diminished expectations are validated: running the `pyside_postinstall.py` script with the `-install` flag gives the following error.

    > pyside_postinstall.py -install
    : command not foundv/versions/scipy2/bin/pyside_postinstall.py: line 6: 
    /usr/local/opt/pyenv/versions/scipy2/bin/pyside_postinstall.py: line 7: import: command not found
    from: can't read /var/mail/os.path
    from: can't read /var/mail/subprocess
    /usr/local/opt/pyenv/versions/scipy2/bin/pyside_postinstall.py: line 10: import: command not found
    : command not foundv/versions/scipy2/bin/pyside_postinstall.py: line 11: 
    : command not foundv/versions/scipy2/bin/pyside_postinstall.py: line 12: 
    : command not foundv/versions/scipy2/bin/pyside_postinstall.py: line 13: try:
    : command not foundv/versions/scipy2/bin/pyside_postinstall.py: line 19: file_created
    /usr/local/opt/pyenv/versions/scipy2/bin/pyside_postinstall.py: line 20: is_bdist_wininst: command not found
    /usr/local/opt/pyenv/versions/scipy2/bin/pyside_postinstall.py: line 21: except: command not found
    /usr/local/opt/pyenv/versions/scipy2/bin/pyside_postinstall.py: line 22: is_bdist_wininst: command not found
    /usr/local/opt/pyenv/versions/scipy2/bin/pyside_postinstall.py: line 23: syntax error near unexpected token `('
    'usr/local/opt/pyenv/versions/scipy2/bin/pyside_postinstall.py: line 23: `    def file_created(file):

[This Stackoverflow exchange][pyside-cmake-err] seems to report a similar situation (within the context of a similar goal: containing project-level PySide installation to a single virtual environment), but with no response as of yet.

Assuming things work right, we will eventually get to the following step.

    pip install ipython[all]

The `[all]` option for IPython installs packages like `jinja2` which are necessary for using IPython Notebooks.  The full list of packages installed is `gnureadline`, `Sphinx`, `numpydoc`, `jinja2`, `docutils`, `markupsafe`.  Then we can give things a try.

    ipython qtconsole --pylab=inline
    ipython notebook --pylab=inline

**... Nope, just garbage.  At least this seems contained to the `scipy2` environment... :-P**

We can try a different tack within the `scipy2` virtual environment: let's try to have IPython run via PyQt.  If we first run `pip uninstall PySide`, followed by `brew uninstall cmake`, then the output is as follows.

    ImportError: 
        Could not load requested Qt binding. Please ensure that
        PyQt4 >= 4.7 or PySide >= 1.0.3 is available,
        and only one is imported per session.
    
        Currently-imported Qt library:   None
        PyQt4 installed:                 False
        PySide >= 1.0.3 installed:       False
        Tried to load:                   ['pyside', 'pyqt']

**... Still garbage... Never disappointed in failure to compile...**

Current Status
--------------

Well, it seems like this is going to be difficult, and I'm not sure it's worth the effort right now.  Probably the best course of action is to go full steam ahead with Python 3.x and let Python 2.x continue on its slow decline unimpeded.  (This is what I wanted to do years ago, but the time required to update NumPy, et al., meant that I had to hang on to 2.x longer than expected.  It seems that particular Rubicon has now been crossed, and so I should only need 2.x for legacy stuff.)  So I'll just let the `scipy2` environment flounder until I, or someone else, find a better solution.

## Quick (Re-)Set-Up Summary

As it turns out, doing `brew update --all` installed a new version of `pyenv`, and this seems to have killed all my virtual environments.  So to get back up and running, here's a summary of the above.

```
\# Get some Homebrew stuff first
brew install qt --with-python3 --build-from-source
brew install pyqt --with-python3 --build-from-source
brew install zeromq
brew install pyenv
brew install pyenv-virtualenv
brew install cmake
brew install gcc

\# Install whatever the latest Pythons are
pyenv install 2.7.11
pyenv install 3.5.1

\# Make some Python 2 and Python 3 environments
pyenv virtualenv 2.7.11 scipy2
pyenv virtualenv 3.5.1 scipy3

\# Some quick upgrades in the Python 3 environment
pyenv activate scipy3
pip install --upgrade setuptools
pip install --upgrade pip

\# Populate the Python 3 environment with useful packages
pyenv activate scipy3
pip install nose
pip install numpy
pip install scipy
pip install matplotlib
pip install pandas
pip install pyzmq
pip install pygments
pip install jsonschema

pip install -U PySide
pyside_postinstall.py -install

pip install ipython[all]

\# And for NLTK
pip install nltk

\# Get out of the Python 3 environment
pyenv deactivate

\# Repeat for the Python 2 environment
pyenv activate scipy2

\# Run the same pip commands as a above
\# But remember IPython will fail because of the Qt compilation mismatch
```


[brew]: http://brew.sh/
[python]: https://www.python.org/
[venv]: https://virtualenv.pypa.io/en/latest/
[venvw]: http://virtualenvwrapper.readthedocs.org/en/latest/
[venvwo]: https://bitbucket.org/dhellmann/virtualenvwrapper/overview
[pyenv]: https://github.com/yyuu/pyenv
[pyenvv]: https://github.com/yyuu/pyenv-virtualenv
[pyenv-slide]: http://www.slideshare.net/MaximAvanov/python-developers-daily-routine-29426666
[pyenv-global-error]: https://github.com/yyuu/pyenv/issues/145
[pyenv-order]: https://github.com/yyuu/pyenv/issues/31
[pyenv-uninstall]: https://github.com/yyuu/pyenv-virtualenv/issues/17
[rvm]: https://rvm.io/
[ipython]: http://ipython.org/
[pip-v]: https://github.com/Homebrew/homebrew/issues/26900
[pip-i1]: http://stackoverflow.com/questions/23276866/python-pip-installation-error
[pip-i2]: http://pip.readthedocs.org/en/latest/installing.html#id8
[ipy-pyenv]: https://github.com/yyuu/pyenv/issues/38
[qt5-pyqt]: https://github.com/Homebrew/homebrew/issues/16471
[pyside]: https://pypi.python.org/pypi/PySide
[pyside-cmake-err]: http://stackoverflow.com/questions/23208965/how-to-pip-install-pyside-on-virtualenv-in-mac-os-x