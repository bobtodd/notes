# Installing Packages in the Local Tree

## Short Version

Looks like my [TeXLive](https://www.tug.org/texlive/) distribution is from 2013.  Even though the latest version, 2015, is about to appear, I should nevertheless update to 2014 before proceeding.  Perhaps the `tikz-er2` package will already be included (though I don't think so).  For that we go to the [MacTeX](https://tug.org/mactex/) distribution website.

**Update**: Nope, no `tikz-er2` in TeXLive 2014.  On to the *long version*...

## Long Version

So I've been using [TeXLive](https://www.tug.org/texlive/) for a while, but I haven't had to install a package by hand since I've started using it.  For some reason, the package `tikz-er2` is not part of the (current: 2013) distribution, so it looks like I'll have to change add that by hand (`tlmgr` doesn't find it).

The trick is to understand where the TeXLive tree is, and where the corresponding local tree is.  My distribution is located here:

```
/usr/local/texlive/2013/
```

And the local TeX tree is parallel to the 2013 folder:

```
/usr/local/texlive/texmf-local/
```

So if I want to install `tikz-er2` by hand, I'll need to place it in the local tree.  Essentially I need to follow the instructions [here](http://tandindorji19.blogspot.com/2012/10/installing-tikz-er2-for-better-er.html).  But they need to be adjusted relative to my path.

We can download `tikz-er2` from [this GitHub repo](https://github.com/stefan-langenmaier/u2r3/blob/master/text/tikz-er2.sty).  Let's assume we've downloaded it to the Desktop.

The new procedure would be as follows.

```
> sudo mkdir /usr/local/texlive/texmf-local/tex/latex/tikz-er2
> cp ~/Desktop/tikz-er2.sty /usr/local/texlive/texmf-local/tex/latex/tikz-er2
> sudo mktexlsr 
```

Alternately, the last command can be replaced by

```
> sudo texhash
```

That should do it.