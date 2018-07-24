# Writing A Modern SFTP Shell

The current sftp implementation on bash is primitive and out-of-date.  There's no history, no tab-completion, and no arrow-key support.  So I decided to write a modern version.  It's a lot easier than it sounds, I just took a couple Python libraries and meshed them together, [pysftp](pysftp.readthedocs.io) and [prompt_toolkit](http://python-prompt-toolkit.readthedocs.io/en/stable/).

## Writing a shell from scratch
I was always going to rely on pysftp for the sftp stuff, but for learning purposes, I wanted to write my own shell.  This was a lot of fun and I did learn a lot, although I didn't end up using my implementation.  The important thing to know when writing a shell is how ANSI codes work.  I based mine mostly on the tutorial found [here](http://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html).  There are ANSI codes for moving the cursor(for arrow keys) for clearing the line(for autocomplete and backspace), for clearing the screen, and in fact there are ANSI codes for anything you could want to do with a terminal.

I wrote enough to get the basics working, then decided to use the fully-fleshed out prompt_toolkit implementation to speed things up.

## Prompt Toolkit
Prompt_Toolkit is a tool for writing shells.  It's got autocomplete options, history options, color options, everything you could possibly want.  I'm using hardly any of what it has to offer.  All it does right now is history and tab-completion.

## Pysftp
Pysftp is a programmatic sftp interface.  Behind the scenes, it maintains a connection to the server and has a bunch of basic commands for uploading and downloading files, and directory navigation.

## The Glue
I glued the two together using `getattr`, which is a python function that dynamically get a function or variable attached to an object.  If the function or variable exists, I return it or call it.  If not, I raise an error that gets passed through to to the shell.  It's pretty neat, and saved me writing a lot of repetitive code for each possible method.

And that's all there is to it!  You can find the code at [my github](github.com/sdubinsky/pysftp-shell).
