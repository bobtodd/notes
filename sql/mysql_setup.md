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

This will give output something like the following.

```
==> Caveats
We've installed your MySQL database without a root password. To secure it run:
    mysql_secure_installation

To connect run:
    mysql -uroot

To have launchd start mysql at login:
  ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
Then to load mysql now:
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
Or, if you don't want/need launchctl, you can just run:
  mysql.server start
==> Summary
🍺  /usr/local/Cellar/mysql/5.7.9: 12629 files, 464M
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


## Securing MySQL

We can also do a little setting up.  According to [this blog post](http://wpguru.co.uk/2015/11/how-to-install-mysql-on-mac-os-x-el-capitan/), it's probably a good idea to secure the installation.

```
> brew services start mysql
==> Successfully started `mysql` (label: homebrew.mxcl.mysql)
> mysql_secure_installation 

Securing the MySQL server deployment.

Connecting to MySQL using a blank password.

VALIDATE PASSWORD PLUGIN can be used to test passwords
and improve security. It checks the strength of password
and allows the users to set only those passwords which are
secure enough. Would you like to setup VALIDATE PASSWORD plugin?

Press y|Y for Yes, any other key for No: n
Please set the password for root here.

New password: 

Re-enter new password: 
By default, a MySQL installation has an anonymous user,
allowing anyone to log into MySQL without having to have
a user account created for them. This is intended only for
testing, and to make the installation go a bit smoother.
You should remove them before moving into a production
environment.

Remove anonymous users? (Press y|Y for Yes, any other key for No) : n

 ... skipping.


Normally, root should only be allowed to connect from
'localhost'. This ensures that someone cannot guess at
the root password from the network.

Disallow root login remotely? (Press y|Y for Yes, any other key for No) : y
Success.

By default, MySQL comes with a database named 'test' that
anyone can access. This is also intended only for testing,
and should be removed before moving into a production
environment.


Remove test database and access to it? (Press y|Y for Yes, any other key for No) : y
 - Dropping test database...
Success.

 - Removing privileges on test database...
Success.

Reloading the privilege tables will ensure that all changes
made so far will take effect immediately.

Reload privilege tables now? (Press y|Y for Yes, any other key for No) : y
Success.

All done! 
> brew services stop mysql
Stopping `mysql`... (might take a while)
==> Successfully stopped `mysql` (label: homebrew.mxcl.mysql)
```

## Localhost

That [useful blog post](http://wpguru.co.uk/2015/11/how-to-install-mysql-on-mac-os-x-el-capitan/) mentioned above also points out some strangeness with using `localhost`.  Specifically,

> MySQL on OS X doesn’t like the value “localhost”. Instead, use 127.0.0.1 (don’t ask me why).

And it also mentions [Sequel Pro](http://sequelpro.com/), a free GUI for MySQL.
