# Getting Started with SQL

So I'm new to [SQL](https://en.wikipedia.org/wiki/SQL), and I'm trying to learn more.  But what I'm finding this that, more than with other programming languages I've learned, SQL comes in a million less-than-compatible flavors.  And it seems fairly standard for many of those flavors to be Windows-only, which doesn't help a Mac-addict and Linux-nerd like myself.  This has the undesirable consequence of actually making it hard to get *started* in the language: not only do I first have to find out not only what flavor of SQL I need to install for a given resource, such as O'Reilly's [*Learning SQL*](http://shop.oreilly.com/product/9780596520847.do) book (which oddly lacks *any* real help on installation), but I also need to figure out how *best* to install it in order to later *remove* it when it turns out that's not the flavor I will use for subsequent work.

For [*Learning SQL*](http://shop.oreilly.com/product/9780596520847.do), the author naturally enough recommends using [MySQL](https://en.wikipedia.org/wiki/MySQL) (downloads [here](http://www.mysql.com/downloads/)).  This has several methods of installation, each of them only partially satisfactory.  Let me explain.

## Installing MySQL on Mac OS X

### Background

First off, if you go to the MySQL [downloads page](http://www.mysql.com/downloads/), you're confronted with a wide variety of versions.  you need to scroll a while and read between the lines: if it says 'trial', that means you pay; if it says 'GPL', that means it's free.  So I guess we want the latter: the [Community](http://dev.mysql.com/downloads/) version.  If you go to the page, it's not clear to the noob what all the different versions mean.  I'm just guessing the [Community Server](http://dev.mysql.com/downloads/mysql/) is what I'd want.

Next, we need to figure out how to install it.  So we go to the [general instructions](https://dev.mysql.com/doc/refman/5.6/en/osx-installation.html).  There you can find out [how to install from a `.dmg` file](https://dev.mysql.com/doc/refman/5.6/en/osx-installation-pkg.html), which looks nice and easy.  In particular, you find there's a nice way to control the server from the [Preference Pane](https://dev.mysql.com/doc/refman/5.6/en/osx-installation-prefpane.html).  That's highly desirable.  [This blog post](http://wpguru.co.uk/2015/11/how-to-install-mysql-on-mac-os-x-el-capitan/) provides a nice outline, with caveats to avoid pitfalls, of how to install using this method.

But experience suggests that, before installing anything from a pre-packaged installer script, it's useful to do a little digging and figure out if the installer comes with an *uninstaller*.  And a little googling shows that many users are frustrated with the fact that there is no clean way to uninstall a MySQL distribution installed in this way.

That brings us to the heart of our story.

### Installing MySQL with Homebrew

If you haven't figured it out already, the following seems to be axiomatic:

> If something's worth installing on Mac, it's worth installing via Homebrew.

Simple as that.  So make sure you have [Homebrew](http://brew.sh/) installed.    Why?  Because Homebrew knows how to *clean up after itself*.  So if you can easily install something via Homebrew, you can easily uninstall it too.  That brings us to the following.

#### The Easy Way Is the Hard Way

A little knowledge of Homebew will allow you to guess the correct procedure:

```
> brew install mysql
```

That's it.

But if you want that little [Preference Pane](https://dev.mysql.com/doc/refman/5.6/en/osx-installation-prefpane.html) magic, then you have to go through some machinations.  You can find a nice explanation in [this *superuser* thread on StackExchange](http://superuser.com/questions/289491/mysql-preference-pane-control-for-mysql-installed-via-homebrew).  The upshot is it can be done.  You start by creating a new directory

```
> mkdir -p /usr/local/mysql; cd /usr/local/mysql
> ln -s $(brew --prefix mysql)/* .
```

and going from there.  The downside, however, is that the Preference Pane for MySQL assumes `mysql` or `_mysql` is the user name, not your own personal user name.  And so you need to muck around with the ownership of the database you're using.

Experience in the context of my University's policy of separating normal user accounts from administrator accounts that Homebrew's relation with file permissions is a tangled web, and it's best to steer clear.  So that means we should probably ditch the idea of the Preference Pane and start/stop the server from the command line.  But that means a whole bunch of new commands that are pretty mysterious to someone just starting out.

But then Homebrew comes to the rescue.  Again.

#### Homebrew Services to the Rescue

Again, a little googling goes a long way.  Homebrew has already figured out how to handle issues like those described about and developed a way of handling starting and stopping background servers like MySQL (and others!) all at one go.  And thanks to Gabe Berke-Williams for writing a [straightforward blog post](https://robots.thoughtbot.com/starting-and-stopping-background-services-with-homebrew) explaining how to get things up and running.

As usual, we just install MySQL as usual with Homebrew:

```
> brew install mysql
```

But now we want to "tap" (standard Homebrew terminology) `homebrew/services`:

```
> brew tap homebrew/services
```

Then we can use a uniform command-line interface for starting and stopping background services, like so:

```
> brew services start mysql    # start server
> brew services stop mysql    # stop server
> brew services restart mysql    # in case weird things start happening
> brew services list    # to find out what's running in the background
> brew services cleanup    # to remove unwanted plist files
```

That's pretty impressive.  And clean.