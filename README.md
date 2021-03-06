Mailpile Tools
==========

This repo is a catch all for miscellaneous fun tools to work on, deploy and futz around with Mailpile. There's not much in this repo yet, but eventually there will be helpful things here!


Dog Fooding Mailpile
--------------------

In order to start dog fooding, we wanted to interact with our team@mailpile.is
email 100% from Mailpile.  We created a simple utility that pulls the latest
master branch from the Mailpile Github account 4 times per day and then
restarts the instance of Mailpile. 

This tool DOES NOT setup and configure Mailpile for you, it just keeps it updated with our master branch. So, in order to use this tool to feel the bleeding edge of the Mailpile experience yourself, do the following steps:

### Install Mailpile

    # Clone Mailpile into your home directory (location matters!)
    $ cd
    $ git clone https://github.com/pagekite/Mailpile.git

    # Follow the README in the Mailpile repo & make sure you have all the depencies installed

### Install Tools

    # Clone tools (you can move to another directory for this)
    $ cd /path/to/wherever/you/keep/tools
    $ git clone https://github.com/mailpile/tools.git

    # Try running the dogfood script, see if it works:
    $ ./tools/dogfood-mp.sh --run

The final step might fail if you have some missing dependencies. Consult
the Mailpile installation instructions for hints on how to resolve those.

If Mailpile runs, then you can install the script into your `crontab` so it
will automatically run in the background and pull down the latest changes
and restart itself four times a day:

    $ ./tools/dogfood-mp.sh --install

For more info (uninstallation, connecting to the running Mailpile), ask the
script itself for help:

    $ ./tools/dogfood-mp.sh --help

That's all folks!
