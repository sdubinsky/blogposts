# Anatomy of a Linux Command

There's a lot you can do in Linux via a GUI (graphical user interface), and if that's how you like using a computer, more power to you.  Every once in a while, though, you're going to want to run a program that doesn't have one, or has options you can't access via the GUI.  Generally, when you run into one of those, you'll look around for help.  The help will come in the form of advice to "run this command" followed by an arcane invocation.  I'm going to teach you how to understand those invocations by teaching you the basics of the conventions used to create them.

## Example 1: `ls -a mydir`

In Bash, by default, commands are split on whitespace (to prevent this, use quotation marks).  That means `ls -a mydir/` is split into `ls`, `-a`, and `mydir/`.  The first part of the command is always the name of the program you're running, and the rest are arguments passed to that program.  

Notice the dash, it's important.  A dash before an argument means it's an option/switch/flag (the terms are synonymous) instead of a normal argument.  Options are generally affect how the program runs, and normal arguments are targets for the program.  In this case, `ls -a mydir/` means "list everything in mydir (the target specified by the normal arguement), even hidden files (the altered behavior specified by the option)."  Although it's not shown here, options can also take their own arguments.  In that case, the argument goes directly after the option and you have to read the man page to find out whether the argument is for the option or to the program itself.

There is no limit in Bash on the number of flags and arguments you can pass to a program, although the program might set its own limits.

## Example 2: `ls -la --human-readable  mydir`

As before, this will split on whitespace and call the `ls` command, this time with three arguments: `-la` , `--human-readable` and `mydir`.  In this section, we're going to focus on the first two, because they represent a couple different ways to use switches.

Instead of specifying multiple flags each with their own dash, you can use one dash for every option.  This means that `ls -la` is exactly the same as `ls -l -a`.  Also, the order doesn't matter.  `ls -al` is exactly the same as `ls -la`.

Many options also have a short and a long version.  As a convention, one dash signifies a short version, and two signifies a long version.  In some cases, where there is only one version, only one dash will be used even for a longer option.  Hope this helps!
