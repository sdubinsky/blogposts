# A Bug Finding Journey

I recently spent a day tracking down a fairly weird and hard-to-find bug.  None of it required advanced coding knowledge, just an understanding of how things work, the ability to read code, and some tenaciousness.  The target audience for this post is newer coders who are intimidated by complex repos, and I want to show that you don't need special skills to do this sort of thing.

## Background

When I build my own websites, I use Sinatra, a minimalist web framework.  It's really nice for small apps, because you can put all your routes in one file with no extraneous boilerplate.  Run that file with Ruby, and your website is up and running.

I created my side business [Title Reader](https://titlereader.com) in Sinatra as well, but since it's a bit more complex I structured it as a more traditional website instead of just a single file.  It also depends on some Rack-only features that aren't included in Sinatra (specifically route prefix mapping).  Instead of running the file directly, I have to include it in the rack config file `config.ru` and run that with the `rackup` command, a gem provided by the Rack team for running Rack apps.

[Rack](https://github.com/rack/rack) is the standard interface for web frameworks and servers in Ruby.  Frameworks are what you write your website in - it's where you define routes and what they return.  Servers are what you run when you start the site.  Having a defined interface means you can mix and match servers and frameworks.  It means you can serve both Rails and Sinatra apps with Puma (the server I use) without having to change Puma, and it means you can switch servers as needed without rewriting any application code.

## The Bug

I use Stripe to handle purchases.  The way Stripe is structured, you have keys to represent different purchase options.  While building the app, I used test keys that show up in Stripe but don't charge anything.  For the real app, of course, I have live keys.

It's standard in the programming world to differentiate between the different environments your code runs in.  At a minimum these are `development` and `production.`  This is exactly why - many times, you'll have fake values for testing and development and live values that should be live on production only.

As I mentioned above, I'm running my site with the `rackup` command.  `rackup` comes with an flag to set the environment, `-E`, so I used that to set the environment.  However, when I tested my app on prod, it was still using the test keys for Stripe, so for some reason my environment isn't being set.

## RACK\_ENV, RAILS\_ENV, APP\_ENV, Oh My

When debugging, the very beginning is the very best place to start.  What does that `-E` flag actually do?  Turns out, it's the equivalent of setting the `RACK_ENV` environment variable.

A bit of background here, if you aren't familiar with Linux programs.  In addition to any command-line arguments you pass in, all programs have access to a list of environment variables that define the environment they run in.  This includes the current directory, the PATH, the user running the program, and so on.  You can also set your own, and by convention they are named in `ALL_CAPS`.  This is different from the development/production environment in the previous section.

Anyway.  `rackup` is setting the `RACK_ENV` var. `RACK_ENV` is not the same thing as your development/production environment either.  It's a Rack-internal variable, and `production` isn't even a valid value.  [This is a common mistake](https://www.hezmatt.org/~mpalmer/blog/2013/10/13/rack_env-its-not-for-you.html), and in fact after a bit more poking it seems like the Rack team is working towards [deprecating it entirely](https://github.com/rack/rack/issues/1546).  So what should I be using instead?

One of the reasons so many people get confused by `RACK_ENV` is that there is a very similarly-named `RAILS_ENV` that does what we want for Rails apps.  If Sinatra were to follow that pattern, we'd use `SINATRA_ENV`.  But there's no reason to duplicate names like that, so the Sinatra team [came up with](https://github.com/sinatra/sinatra/pull/984) `APP_ENV` and that's now become the standard for Ruby frameworks.  I set `APP_ENV` appropriately for my production system, pushed, and went to check again.

## If I Fixed It, Why Isn't It Working?

Conveniently, Puma will tell you what environment it's running under when you start it.  And, when I checked it after pushing the `APP_ENV` fix, it was still running in development mode.  What's going on?

It's hard (and just generally a bad idea) to do your debugging on prod, so I tried to reproduce it on my local machine.  This wasn't difficult - I just had to set the `APP_ENV` env variable before my `rackup` call.  As expected, Sinatra ran in production mode and Puma ran in development mode.

Maybe Sinatra or Rack is deleting it somewhere?  It would be weird, but stranger things have happened.  It's not listed in the docs anywhere, but maybe there's a default value being set that I'm missing.  The most obvious place to look is where Sinatra is deciding to run Puma.  It's not explicitly specified in my code anywhere, it's happening automatically.  So time to read the code!

## Spelunking

Reading code is an underrated skill for a developer.  Docs are essential but frequently incomplete, and there's no replacement for being able to see what's actually happening.  You don't have to understand the whole codebase to find what you want, just know where to look.

In Sinatra, the obvious first place to look is `main.rb`.  It's a pretty small file, and the only line that really does anything calls `Application.run!`.  That class is defined in `base.rb` which is...not a small file.  Fortunately, since we know what we're looking for, we can search for it directly.  Although the file itself is huge, the `run!` method itself is pretty small.  It creates a bunch of variables and calls `start_server`.  The interesting line for us is the one that creates the `handler`.  It's using a `server` variable that isn't defined in the method, so where is it coming from?  Searching the file for "server" returns 38 results.  Most of them are false positives, but it's quick enough to scan through them.  What it does show is that `server` is a list of server types, and Puma is hardcoded to be part of it.

There's nothing in Sinatra that would clear `APP_ENV`, but there is that call to `Rack::Handler.pick` to choose from the list of servers.  If we look at the code there, it takes a list of servers and chooses the first one it can successfully load.  There's nothing there either that would clear or override `APP_ENV`.

## Minimal Working Example

I'm at a bit of a dead end now.  _Something_ is broken, but I can't find what it is.  And when I'm at a dead end, I like to start narrowing down the possibilities.  This is also known as creating a minimal working example - just enough code to show the bug, and no more.

If I run a basic Puma server with `$ APP_ENV=production puma`, it runs in production mode.  I already know that Sinatra respects `APP_ENV` on its own, and now I know that Puma does as well.  So it's something about the combination of Sinatra and Puma that's causing issues.

The bug is in a combination of Sinatra and Puma.  That means I need a Gemfile with Sinatra and Puma, and a simple app.rb file for my app.  Easy enough to spin up.  As I said at the beginning, just gotta run the app file.  `APP_ENV=production bundle exec ruby app.rb`.

H-uh.  That's weird.  Puma is running in production mode, exactly as I want.  Maybe there's something in `rackup` that's causing the problem?  The nice part about having a MWE is that it's really easy to change.  I added a `config.ru` file, as `rackup` wants, and ran that.  Sure enough, Puma is back in development mode.  Bingo!

This still isn't quite a MWE, though.  Rack is an interface between frameworks and servers, but you can write endpoints in Rack directly, without using an external framework.  That means we don't need Sinatra.  And, in fact, when I remove Sinatra, I get the same error!  With this, I have enough to file [a bug report](https://github.com/rack/rackup/issues/3) against the `rackup` gem.

## Conclusion

I hope you enjoyed this tour.  Some of the steps here were probably faster because of my prior familiarity with web development in Ruby, but none of them require deep knowledge of the internals of any of the gems.  All it takes is willingness to get started and stick to it until you find the issue.
