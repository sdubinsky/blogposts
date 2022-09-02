# An Oral History of Git

Linus Torvalds, the creator of Linux, wrote Git as a source code management system (SCM) for the Linux kernel.  Legend has it he wrote the whole thing in a weekend, and it was perfect.  I was interested in how it all happened, so I went through the Linux Kernel Mailing List (LKML) for April 2005 looking for the real story.  What I found was a series of emails that detail the beginning of one of the most successful pieces of software of all time.  It started with frustration, and ended with usecases never dreamed of by its creator.

A short bit of background.  Development on the Linux kernel started in 1991 and it quickly turned into an enormous and complex software project with almost unique requirements for its source code management. In 2002 the Linux kernel project started using a proprietary SCM tool called BitKeeper, provided free by the owner.  In 2005, he revoked their free access over a licensing dispute.  The subject line of the first email is "Kernel SCM saga..." which seems appropriate.

## April 6, 2005 - "the kernel team is looking at alternatives"

[Linus Torvalds, LKML 2005/04/06](https://lkml.org/lkml/2005/4/6/121)

>as a number of people are already aware (and in some cases have been aware over the last several weeks), we've been trying to work out a conflict over BK usage over the last month or two (and it feels like longer ;). That hasn't been working out

The kernel team had been very happy with BitKeeper, and Linus made a point of that in this email:

>the biggest problem right now is that a number of people have gotten very very picky about their tools after having used the best.

Linus even credits BitKeeper with helping the kernel development team design a better workflow, and one of his goals was to find a system that let him keep the same process: 

>one impact BK ha shad(sic) is to very fundamentally make us (and me in particular) change how we do things...I'm convinced it caused us to do things in better ways, and one of the things I'm looking at is to make sure that those things continue to work.

But after two months of trying to negotiate with the owner of BitKeeper over continued usage, Linus gave up.  At this point, Linus still had no real intention of making Git.  He was hoping to find a good open source alternative, and was seriously considering a program called Monotone.  Most of the others he looked at were just too slow for his process: 

>However, the SCM's I've looked at make this hard.  One of the things (the main thing, in fact) I've been working at is to make that process really \_efficient\_. If it takes half a minute to apply a patch and remember the changeset boundary etc (and quite frankly, that's \_fast\_ for most SCM's around for a project the size of Linux), then a series of 250 emails (which is not unheard of at all when I sync with Andrew, for example) takes two hours. If one of the patches in the middle doesn't apply, things are bad bad bad.

## April 7, 2005 - "I bet you could make a reasonable SCM on top of it, though"

[Linus Torvalds, LKML 2005/04/06](https://lkml.org/lkml/2005/4/8/9)

>a heavily sedated sloth with no legs is probably faster...The kernel is ten times larger, so does that mean to do a clean pull of the kernel we are looking at (71/2*10) ~ 355 minutes or 6 hours of CPU time?

So says Chris Wedgwood, who was the first LKML member to take a serious look at Monotone.  It took Chris over two hours of wall clock time to pull just the Monotone repo itself - and the kernel source, a much larger codebase, was going to be even worse.  Linus decided to take a look for himself, and got so bored waiting for Monotone to do stuff that he wrote the beginnings of Git specifically to be a fast SCM-like.  It hardly did anything - just tracked filesystem changes, but this is the first mention of Git on the LKML.  It all started here:

>In the meantime (and because monotone really _is_ that slow), here's a quick challenge for you, and any crazy hacker out there: if you want to play with something _really_ nasty (but also very _very_ fast), take a look at kernel.org:/pub/linux/kernel/people/torvalds/.

Not only was there no such thing as a remote, there wasn't even such a thing as a merge.  Linus described it as 

>...not an SCM, it's a distribution and archival mechanism.

Basically a second filesystem, that tracks and saves changes.  [Slightly later](https://lkml.org/lkml/2005/4/8/172) in the thread, Linus defines a commit for the first time: 

>I call this "commit", but it's really something much simpler. It's really just a "I now have \<this directory state\>, I got here from \<collection of previous directory states\> and the reason was \<reason\>".

He's very consistent about one thing throughout: Git is designed specifically for Linus and his workflow as Linux maintainer. 

>[it's all definitely optimized for
the things that \_I\_ tend to care about](https://lkml.org/lkml/2005/4/8/267)

and 

>[The real downside of GIT may be that \_my\_ way of doing things is quite possibly very rare](https://lkml.org/lkml/2005/4/8/267)

and others.

## April 10, 2005 - "aimed at human usability and to an extent SCM-like usage"

[Petr "Pasky" Baudis, LKML 2005/04/10](https://lkml.org/lkml/2005/4/10/72)

>I "released" git-pasky-0.1, my set of patches and scripts upon Linus' git, aimed at human usability and to an extent a SCM-like usage.

This email marks the first official release of third-party additions to Git, beginning a grand tradition that includes the likes of [Sourcetree](https://www.sourcetreeapp.com/), [GitKraken](https://www.gitkraken.com/), [Magit](https://magit.vc/), and many more.  This is also the first mention of the `git pull` command - not written by Linus, but added on top of what he had written.

[Later releases](https://lkml.org/lkml/2005/4/10/202)(the very next day) included some major usability improvements, such as allowing you to just use an unambiguous prefix for the SHA1 hash.  I personally remember it being something of a big deal a few years ago when the kernel got so large they needed an extra digit for their prefixes.

## April 25, 2005 - "This is to announce an updated version of Mercurial"

[Matt Mackall, LKML 2005/04/25](https://lkml.org/lkml/2005/4/25/267)

>While disk may be cheap, network bandwidth is not. Given that the common case usage of git will be to do network pulls, it will find most of its speed wasted on waiting for the network. Mercurial will almost certainly win here for typical developer usage as it can do efficient delta communication (though it currently doesn't attempt any pipelining so suffers a bit in round trips).

Mercurial (hg for short) is the main competitor to Git nowadays.  Started just a few days after Git, hg uses a delta model of tracking changes instead of Git's full-file model.  This email was its creator's attempt to get Linux to switch, and probably Mercurial's best chance of becoming the preeminent SCM.  Git's defenders [rose to the challenge](https://lkml.org/lkml/2005/4/29/36).  The whole thread is full of benchmarks and time test results, and there's also a lot of talk about whether any specific shortcoming is a real shortcoming or "we just haven't implemented that yet" or "you can do that very easily."  In other words, the usual sort of internet argument where all participants are already convinced they're right.  After much back-and-forth, Matt summarizes the argument: 

>[git] trades 10x disk space for maybe 10% performance relative to my approach."

[That's about when](https://lkml.org/lkml/2005/4/29/106) Linus steps in and reframes the entire argument:

>You've not mentioned two out of my three design goals: distribution and reliability/trustability..."disk space" wasn't one of them, so you've concentrated on only one so far in your arguments."

That thread is a much more interesting read, and if you want a really great discussion of the differences between hg and Git, I highly recommend it.  In the end, Linus likes simplicity, and Git had(and has) a simpler model, and that's all there was to it.

[This email](https://lkml.org/lkml/2005/5/2/202) is a great example.  Mercurial uses deltas to track changes.  In other words, if a file changes, Mercurial will record the changes made instead of a whole new copy of the file.  Git stores the entire new file, even if only a small part changed.  To ensure no data is lost, Mercurial has a lot of metadata integrity checks.  In contrast, here's how Linus describes Git's approach: 

>So git really validates the \_only\_ thing that matters: it validates the state of the data. It doesn't validate anything else, but if(sic) validates that one thing very completely indeed.

This email also explains, almost incidentally, the confusion around whether or not Git stores full file objects or deltas: 

>Building indeces on top of git would be stupid. You can \_cache\_ deltas, but there's a big difference between a index that actually describes how random blobs go together, and a cache of a delta between two well-specified end-points. And in particular, there is no "consistency" to a delta. You don't need it.

In other words, Git stores full file objects, both in practice and conceptually.  Sometimes, as an efficiency measure, it uses deltas, but only as a caching mechanism.

## May 26, 2005 - "Hopefully, this email can quick-start some people on git"

[Jeff Garzik, LKML 2005/05/26](https://lkml.org/lkml/2005/5/26/11)

>I thought I would write up a quick guide describing how to mess around with the netdev and libata-dev trees, and with git in general.

This is the first public tutorial for using Git - up to this point, everyone had either learned it from the internal readme or from reading the source code.  A few notable things from the list:

* You have to make the `.git` directory yourself.
* Getting new code uses rsync.  There is still no `git pull` in Git itself.
* `git status` doesn't exist yet.
* Git config doesn't exist yet.  All of your personal info must be passed in as an environment variables.

People use Git nowadays for everything from backups to deployment, but this is where it all started - with a slow program and a bored and frustrated Linus.  He really did get the first version out in two days, and the basic conceptual model has stayed about the same ever since.  There have been almost 60,000 commits to master since then, though, and the latest was just five days ago(as of writing this).  Oh, and fun fact - [they knew SHA1 was going to cause problems](https://lkml.org/lkml/2005/4/10/12).
