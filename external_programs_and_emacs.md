# External Programs And Emacs

The Emacs philosophy is "do everything in Emacs."  To that end, there are many emacs modes that act as frontends to external command-line programs such as [ledger](https://www.ledger-cli.org/).  One common problem is that, depending on how you start your Emacs, it might complain about being unable to find those external programs.  This is a common problem if you start Emacs as a systemd service or if you use the GUI version on a Mac.

## The Problem

By default, Emacs sets its path to whatever the path is in the environment where Emacs is started.  If you start Emacs from your terminal, Emacs inherits the `$PATH` you've already set.  If you start Emacs from the Mac GUI program, it'll inherit the default `$PATH`, which doesn't include any custom setup you've done in your `.bashrc` or any other user-specific path info.  Similarly with systemd - you only get the default `$PATH`.  The default `$PATH` doesn't point to any of your user-specific binaries, and that's why Emacs can't find them.

## The Solution

You can, in systemd, set a custom path as part of the service definition, but there's a better way.  Steve Purcell has come out with a little Emacs package called `[exec-path-from-shell](https://github.com/purcell/exec-path-from-shell)` that reads your environment variables, such as your `$PATH` and adds them to Emacs.

To use it(along with `package.el`) add the following to your `init.el`:

```lisp
(use-package exec-path-from-shell
    :config
    (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize))
    :defer 0)
```

If you don't use `package.el`, then install it yourself and just use the third and fourth lines.
