# Installing *R* via Homebrew

This requires the following dependencies: `readline, gettext, xz, libpng, freetype, fontconfig, pixman, li`.  The output from Homebrew is as follows:

```
06:04 PM mbpbt:~> brew tap homebrew/science
Cloning into '/usr/local/Library/Taps/homebrew/homebrew-science'...
remote: Counting objects: 6203, done.
remote: Compressing objects: 100% (12/12), done.
remote: Total 6203 (delta 3), reused 0 (delta 0)
Receiving objects: 100% (6203/6203), 1.58 MiB | 777 KiB/s, done.
Resolving deltas: 100% (3300/3300), done.
Tapped 362 formulae
06:04 PM mbpbt:~> brew install r
==> Installing dependencies for r: readline, gettext, xz, libpng, freetype, fontconfig, pixman, li
==> Installing r dependency: readline
==> Downloading https://downloads.sf.net/project/machomebrew/Bottles/readline-6.3.8.mavericks.bottle.tar.
######################################################################## 100.0%
==> Pouring readline-6.3.8.mavericks.bottle.tar.gz
==> Caveats
This formula is keg-only, which means it was not symlinked into /usr/local.

Mac OS X provides similar software, and installing this software in
parallel can cause all kinds of trouble.

OS X provides the BSD libedit library, which shadows libreadline.
In order to prevent conflicts when programs look for libreadline we are
defaulting this GNU Readline installation to keg-only.

Generally there are no consequences of this for you. If you build your
own software and it requires this formula, you'll need to add to your
build variables:

    LDFLAGS:  -L/usr/local/opt/readline/lib
    CPPFLAGS: -I/usr/local/opt/readline/include

==> Summary
🍺  /usr/local/Cellar/readline/6.3.8: 40 files, 2.1M
==> Installing r dependency: gettext
==> Downloading https://downloads.sf.net/project/machomebrew/Bottles/gettext-0.19.2.mavericks.bottle.tar.
######################################################################## 100.0%
==> Pouring gettext-0.19.2.mavericks.bottle.tar.gz
==> Caveats
This formula is keg-only, which means it was not symlinked into /usr/local.

Mac OS X provides similar software, and installing this software in
parallel can cause all kinds of trouble.

OS X provides the BSD gettext library and some software gets confused if both are in the library path.

Generally there are no consequences of this for you. If you build your
own software and it requires this formula, you'll need to add to your
build variables:

    LDFLAGS:  -L/usr/local/opt/gettext/lib
    CPPFLAGS: -I/usr/local/opt/gettext/include

==> Summary
🍺  /usr/local/Cellar/gettext/0.19.2: 1920 files, 18M
==> Installing r dependency: xz
==> Downloading https://downloads.sf.net/project/machomebrew/Bottles/xz-5.0.7.mavericks.bottle.tar.gz
######################################################################## 100.0%
==> Pouring xz-5.0.7.mavericks.bottle.tar.gz
🍺  /usr/local/Cellar/xz/5.0.7: 58 files, 1.5M
==> Installing r dependency: libpng
==> Downloading https://downloads.sf.net/project/libpng/libpng16/1.6.13/libpng-1.6.13.tar.xz
######################################################################## 100.0%
==> ./configure --disable-silent-rules --prefix=/usr/local/Cellar/libpng/1.6.13
==> make install
🍺  /usr/local/Cellar/libpng/1.6.13: 17 files, 1.7M, built in 37 seconds
==> Installing r dependency: freetype
==> Downloading https://downloads.sf.net/project/machomebrew/Bottles/freetype-2.5.3_1.mavericks.bottle.1.
######################################################################## 100.0%
==> Pouring freetype-2.5.3_1.mavericks.bottle.1.tar.gz
🍺  /usr/local/Cellar/freetype/2.5.3_1: 60 files, 2.5M
==> Installing r dependency: fontconfig
==> Downloading https://downloads.sf.net/project/machomebrew/Bottles/fontconfig-2.11.1.mavericks.bottle.2
######################################################################## 100.0%
==> Pouring fontconfig-2.11.1.mavericks.bottle.2.tar.gz
==> /usr/local/Cellar/fontconfig/2.11.1/bin/fc-cache -frv
🍺  /usr/local/Cellar/fontconfig/2.11.1: 448 files, 3.6M
==> Installing r dependency: pixman
==> Downloading https://downloads.sf.net/project/machomebrew/Bottles/pixman-0.32.6.mavericks.bottle.tar.g
######################################################################## 100.0%
==> Pouring pixman-0.32.6.mavericks.bottle.tar.gz
🍺  /usr/local/Cellar/pixman/0.32.6: 11 files, 1.4M
==> Installing r dependency: libffi
==> Downloading https://downloads.sf.net/project/machomebrew/Bottles/libffi-3.0.13.mavericks.bottle.tar.g
######################################################################## 100.0%
==> Pouring libffi-3.0.13.mavericks.bottle.tar.gz
==> Caveats
This formula is keg-only, which means it was not symlinked into /usr/local.

Mac OS X already provides this software and installing another version in
parallel can cause all kinds of trouble.

Some formulae require a newer version of libffi.

Generally there are no consequences of this for you. If you build your
own software and it requires this formula, you'll need to add to your
build variables:

    LDFLAGS:  -L/usr/local/opt/libffi/lib

==> Summary
🍺  /usr/local/Cellar/libffi/3.0.13: 13 files, 388K
==> Installing r dependency: glib
==> Downloading https://downloads.sf.net/project/machomebrew/Bottles/glib-2.42.0.mavericks.bottle.tar.gz
######################################################################## 100.0%
==> Pouring glib-2.42.0.mavericks.bottle.tar.gz
🍺  /usr/local/Cellar/glib/2.42.0: 410 files, 18M
==> Installing r dependency: cairo
==> Downloading https://downloads.sf.net/project/machomebrew/Bottles/cairo-1.12.16_1.mavericks.bottle.tar
######################################################################## 100.0%
==> Pouring cairo-1.12.16_1.mavericks.bottle.tar.gz
🍺  /usr/local/Cellar/cairo/1.12.16_1: 105 files, 7.6M
==> Installing r
==> Using Homebrew-provided fortran compiler.
This may be changed by setting the FC environment variable.
==> Downloading http://cran.rstudio.com/src/base/R-3/R-3.1.1.tar.gz
######################################################################## 100.0%
==> ./configure --prefix=/usr/local/Cellar/r/3.1.1 --with-libintl-prefix=/usr/local/opt/gettext --with-aq
==> make
==> make check 2>&1 | tee make-check.log
==> make install
==> Downloading https://rcompletion.googlecode.com/svn-history/r28/trunk/bash_completion/R
######################################################################## 100.0%
==> make
==> make install
==> Caveats
To enable rJava support, run the following command:
  R CMD javareconf JAVA_CPPFLAGS=-I/System/Library/Frameworks/JavaVM.framework/Headers

Bash completion has been installed to:
  /usr/local/etc/bash_completion.d
==> Summary
🍺  /usr/local/Cellar/r/3.1.1: 2148 files, 58M, built in 17.7 minutes
06:30 PM mbpbt:~> 
```

And adding JAGS:

```
06:30 PM mbpbt:~> brew install jags
==> Using Homebrew-provided fortran compiler.
This may be changed by setting the FC environment variable.
==> Downloading https://downloads.sourceforge.net/project/mcmc-jags/JAGS/3.x/Source/JAGS-3.4.0.tar.gz
######################################################################## 100.0%
==> ./configure --prefix=/usr/local/Cellar/jags/3.4.0
==> make install
🍺  /usr/local/Cellar/jags/3.4.0: 97 files, 2.4M, built in 3.2 minutes
06:35 PM mbpbt:~> 
```
