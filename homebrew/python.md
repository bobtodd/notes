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

Next, based on other [Pip installation errors][pip-i1] and comments [here][pip-i2, we no longer seem to need to upgrade the Distribute package; upgrading Setuptools is enough.  We follow that with an upgrade to Pip itself.

    pip install --upgrade setuptools
    pip install --upgrade pip

Incidentally, the system also has older Python 3s installed.  So it's probably simpler to install the Homebrew version to override those.

    brew install python --build-from-source
    pip3 install --upgrade setuptools
    pip3 install --upgrade pip

That's just so that I can keep the system current and not have to mess around with the various Frameworks varieties of Python installed on the system.  (Perhaps these can be removed once I figure out how to set a default Python via [Pyenv][pyenv]... ah, it can be done with the `global` command.)



Python Installation via Pyenv (with Help from Homebrew)
-------------------------------------------------------

For real hacking, we can work with [Pyenv][pyenv] and get some fine-tuned control over the Pythons we install and the packages installed corresponding either to the various Pythons or to the various projects (with various Pythons).

    brew install pyenv

Homebrew also provides a suggestion for using Homebrew's own directories rather than `~/.pyenv`, which seems like a good idea: we add the line

    export PYENV_ROOT=/usr/local/opt/pyenv

to the `~/.bashrc` file.  Then I need to add the line (this must come *after* the preceding line)

    if which pyenv > /dev/null;
      then eval "$(pyenv init -)";
    fi

to my `~/.bashrc` file.  (Beware: the order of the lines `export PYENV_ROOT` and `if which pyenv... fi` is important.  See [this issue report][pyenv-order].)  Then we `source` it.

    source ~/.bashrc

This evidently enables the use of shims that Pyenv is based on, and it allows autocompletion (which is a beautiful thing).  Then we add Pyenv-Virtualenv.

    brew install pyenv-virtualenv

That should do it.



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

The package NumPy requires the Fortran compiler.  This is most conveniently installed via Homebrew.

    brew install gfortran

With that installed, I can now go ahead and set up the packages I want for my respective scientific sandboxes.  First I'll set up the sandbox with Python 3.

    pyenv activate scipy3
    pip install nose
    pip install numpy
    pip install scipy
    pip install matplotlib
    pip install pandas

Now for the same with Python 2.

    pyenv activate scipy2
    pip install nose
    pip install numpy
    pip install scipy
    pip install matplotlib
    pip install pandas



Setting up IPython
------------------

I want to be able to use IPython both via the Qt Console and via Notebooks.  The real problem here has traditionally compiling Qt on the machine: Homebrew installs Qt compiled against the Homebrew installed Python.

    pyenv deactivate
    brew install qt
    brew install pyqt
    brew install zmq

Since Qt versions < 4 compile against Python 2.x, let's see how things work in the `scipy2` virtual environment.

    pyenv activate scipy2
    pip install pyzmq
    pip install pygments

Assuming things work right, we will eventually get to the following step.

    pip install ipython[all]

The `[all]` option for IPython installs packages like `jinja2` which are necessary for using IPython Notebooks.  Then we can give things a try.

    ipython qtconsole --pylab=inline
    ipython notebook --pylab=inline

**... Nope, just garbage.  I'll have to rethink the whole sequence... :-P**

Now let's see what happens when we go back and try to get this to work for Python 3.x.

    pyenv activate scipy3
    pip install pyzmq
    pip install pygments
    pip install ipython[all]
    
    ipython qtconsole --pylab=inline
    ipython notebook --pylab=inline

Crossing my fingers...

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
[rvm]: https://rvm.io/
[ipython]: http://ipython.org/
[pip-v]: https://github.com/Homebrew/homebrew/issues/26900
[pip-i1]: http://stackoverflow.com/questions/23276866/python-pip-installation-error
[pip-i2]: http://pip.readthedocs.org/en/latest/installing.html#id8
[ipy-pyenv]: https://github.com/yyuu/pyenv/issues/38