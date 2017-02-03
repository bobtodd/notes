# Email Migration

These are some notes on how to migrate from one email account to another.

## Gmail to Gmail

Some great sources for how to perform the process are the following discussions.

* "[How to Migrate Your Google Account to a New One](http://www.howtogeek.com/148036/how-to-migrate-your-google-account-to-a-new-one/)"
* "[Move or Copy Mail From One Gmail Account to Another](https://www.lifewire.com/move-or-copy-mail-from-one-gmail-account-to-another-1171948)"

Of these I found the [first one](http://www.howtogeek.com/148036/how-to-migrate-your-google-account-to-a-new-one/) most helpful and robust.  It's also similar to guidelines outlined by UT's Math Department.

But in the course of searching the web, I also came across this great command line tool:

* [Got Your Back (GYB)](https://github.com/jay0lee/got-your-back/wiki)

whose source code is on GitHub.  So I'm trying the procedure outlined by GYB, but complemented by some points learned from the "[How to Migrate...](http://www.howtogeek.com/148036/how-to-migrate-your-google-account-to-a-new-one/)" article listed first above.

## Setup

First, save the **filters** from the old account:

* Go to Settings > Filters,
* Check each filter to back up,
* Click Export button at the bottom.

The browser will prompt you to download `mailFilters.xml`, which you can set aside for the moment.

Next, download GYB from the [release page](https://github.com/jay0lee/got-your-back/releases).  Unzip the file to a folder placed somewhere convenient (I left it on the Desktop): `~/Desktop/gyb/`.

Set up GYB by the following:

```
> ./gyb --email old_address@gmail.com --action estimate
```

The command prompt will say

```
Select the actions you wish GYB to be able to perform for tbkutexas@gmail.com

[ ]  0)  Gmail Backup And Restore - read/write mailbox access
[ ]  1)  Gmail Backup Only - read-only mailbox access
[ ]  2)  Gmail Restore Only - write-only mailbox access and label management
[*]  3)  Gmail Full Access - read/write mailbox access and message purge
[ ]  4)  No Gmail Access

[*]  5)  Groups Restore - write to Google Apps Groups Archive
[*]  6)  Storage Quota - Drive app config scope used for --action quota

      7)  Continue
```

I hit `0` for Backup and Restore, then hit `7` to continue.

A browser window will open asking you to log into the address listed in the command and allow GYB access to the account's data.

Eventually the progress looked like so:

```
Authentication successful.
Got 34744 Message IDs                                                           
GYB needs to examine 34744 messages
GYB already has a backup of 0 messages
GYB needs to estimate 34744 messages
Estimated size 2.70gb 34744/34744 messages                                      
```

It creates a folder `GYB-GMail-Backup-old_address@gmail.com/` as a subfolder of `gyb/`.

## Backup

To actually perform the backup, run the following command.

```
> ./gyb --email old_address@gmail.com --action backup
```

It creates a folder `GYB-GMail-Backup-old_address@gmail.com/` as a subfolder of `gyb/`.

The output looks like so:

```
Using backup folder GYB-GMail-Backup-tbkutexas@gmail.com
Got 34744 Message IDs                                                           
GYB needs to examine 34744 messages
GYB already has a backup of 0 messages
GYB needs to backup 34744 messages
backed up 34744 of 34744 messages                                               

GYB needs to refresh 0 messages
```

## Restore

In order to restore to an account with an address **different** from that of the account we backed up, we must specify the name of the backup folder.  So we run the following command:

```
> ./gyb --email new_address@gmail.com --action restore --local-folder GYB-GMail-Backup-old_address@gmail.com --label-restored "Old Address"
```

The `--label-restored` flag tells GYB to apply the label that follows to all the messages restored to the new account.

The command prompt displays the following.

```
Select the actions you wish GYB to be able to perform for bobtodd@utexas.edu

[ ]  0)  Gmail Backup And Restore - read/write mailbox access
[ ]  1)  Gmail Backup Only - read-only mailbox access
[ ]  2)  Gmail Restore Only - write-only mailbox access and label management
[*]  3)  Gmail Full Access - read/write mailbox access and message purge
[ ]  4)  No Gmail Access

[*]  5)  Groups Restore - write to Google Apps Groups Archive
[*]  6)  Storage Quota - Drive app config scope used for --action quota

      7)  Continue

```

I chose `0` and `7`.  A browser window then pops up as before, and you must log into the new Gmail account.

### Note: Restarting

GYB keeps track of its progress.  If it aborts for some reason, as in the following

```
Using backup folder GYB-GMail-Backup-old_address@gmail.com
restoring 10 messages (1424/34744)                                              
409: Label name exists or conflicts - aborted
```

you can re-execute the command and it will pick up where it left off.

```
> ./gyb --email new_address@gmail.com --action restore --local-folder GYB-GMail-Backup-old_address@gmail.com --label-restored "Old Address"

Using backup folder GYB-GMail-Backup-old_address@gmail.com
restoring 10 messages (254/33320)
```

### Import Filters

Log into the new account.  Then

* Go to Settings > Filters,
* Click on Import Filters at the bottom,
* Select the `mailFilters.xml` file we saved earlier,
* Click Open File,
* Scroll to the bottom and click "Apply new filters to existing email" if desired,
* Click Create Filters.