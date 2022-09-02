# The Four Ways To Set Your Path On Mac OSX

Number three will surprise you!  This post courtesy of the six hours I spent trying to figure out how the hell RVM still had stuff in my `$PATH`.

## .bashrc/.bash_profile/.profile

I was reading a blogpost that recommended using ctags, so I decided to install it.  Turns out, I already had it installed but it wasn't first in the `$PATH` so bash couldn't find it.  That's odd, because brew is usually pretty good at setting up symlinks.  `echo $PATH` gave me some enormous list, ending with a bunch of RVM directories that don't even exist!  I switched to chruby months ago.  So I double checked, and found a couple lines in .bash_profile that were adding rvm.  I removed them, but it didn't fix the problem.

## /etc/paths

I had to go deeper.  Where does the default `$PATH` get set?  The one the system itself uses to find programs, before it reads `.bashrc`.  Courtesy of [this StackOverflow question](https://stackoverflow.com/questions/9832770/where-is-the-default-terminal-path-located-on-mac), I learned that on a mac, there's a program called `path_helper`, only accessible with sudo.  It looks in two places.  The preset system paths are in `/etc/paths`, which just contains the location of the default bin directories.  Nothing in there.

## /etc/paths.d/

But there's a second place `path_helper` checks for directories to add.  Programs can add files to `/etc/paths.d`, and `path_helper` will add those to the default path as well.  Mine contains four files, for wireshark, mono, tex, and xquartz.  Interesting and random, but not useful.

## launchctl

While I was googling, I found a few references to launchctl setting `$PATH`.  I assumed that was a runtime configuration of some sort, and I couldn't remember ever actually setting it.  I was reduced to repeatedly reinstalling my terminal, because a fresh install didn't have the `$PATH` issues until it loaded 99% of my .bashrc.  Seriously, if I commented out the last two lines, it worked, but if I loaded all of it RVM appeared again.

It seemed wildly unlikely that `export EDITOR='emacs'` was causing the issue, though, so I kept looking and eventually found [this unanswered SO question](https://stackoverflow.com/questions/51636338/what-does-launchctl-config-user-path-do).  There is in fact a persistent `$PATH` set by launchctl, and rvm had ended up in that.  You can clear it out with `sudo launchctl config user path ''`.

## Conclusion

There was a happy ending, ctags works now, and I know even more useless information about macs.  And so do you!
