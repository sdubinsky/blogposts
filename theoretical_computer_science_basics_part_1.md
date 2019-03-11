# Basics of Theoretical Computer Science, Part One

This is part one of a series on the basics of computer science theory, from a practical perspective.  It's aimed at programmers who have learned the mechanics of programming, but are missing the overall theory that explains why we do things the way we do.  Part one will cover state, state machines, and Turing machines.  Later sections will cover data structures, algorithms and algorithmic complexity, formal language theory, and the lambda calculus.

## What is Computer Science? Information and Abstraction

At its core, computer science is about the transformation and organization of information.  To do this, you have to decide what information is important and what isn't.  Selecting the important pieces of information and discarding the stuff you don't care about is called abstraction[^1], and it's a fundamental skill in computer science.  You can either cut the unimportant info away entirely or mash multiple pieces of information together and treat them collectively as one unit.

The thing about deciding what's important and what isn't is that if you change your perspective, the information you want to abstract away changes.  For example, there's a massive amount of information about each and every subway train.  You as a passenger can ignore almost all of it except where and when the train is going, and abstract it into "a red line train leaving Metro Center at 12:30."  On the other hand, if you're a mechanic, you need a lot more of that information, but not where it's supposed to be going at that particular time.  We'll be using abstraction to cut things down into their simplest possible version.  This is to make them easier to reason about in general terms.

The fundamental SI unit of length is the meter.  The fundamental unit of time is the second.  The fundamental unit of information is the bit.  A bit can hold one of two possible values.  Conceptually, this is the answer to the simplest possible type of question, a yes or no question(or true/false).  If you need more information, you can add more bits, which is the same as getting answers to more yes-or-no questions.  Very quickly, you'll get enough answers to uniquely identify whatever you're interested in.  You may recognize this as the same basic principle as in 20 Questions.  The only difference is that in computer science we use 1/0 instead of yes/no.

If you have the answers to a lot of questions, and you line them all up together, it'll look something like: `110101`.  In technical terms, a series of bits like this where each position in the series represents the answer to a question is called a bitmap.  It's commonly used to represent settings, because it's easy to check whether something is set or not[^2].  Sockets in C, for example, use a bitmap to determine what kind of socket to create.

## State and State Machines

So you have a series of bits that collectively mean something.  This is called the state of the object.  And remember, we can abstract away anything.  We can even abstract away the individual bits by changing the representation of what we're describing.  It's important to realize that changing the representation doesn't change the thing itself, or any of the information we have about it.  It just changes the way it looks.  You can use any symbol you want to represent the object, although some representations are more useful than others.  8, IIX, and 'eight' all represent the same thing, although you'd only want to do math with one of them.  And that's state: A collection of the relevant information about an object, formalized and represented by a symbol or series of symbols.

Remember abstraction?  One of the things we can abstract away is the object itself, so that all we have left is the state.  In other words, we can say "this symbol represents the state of a hypothetical object, it doesn't represent anything in particular."  Most of computer science works with these generic symbols, because it lets you make more general statements, meaning they apply to more things.

Having state is all well and good, but the one constant in the universe is "things change" so we need some way to represent that change.  Finite state machines(FSMs), also called finite automata, are the most common way to represent change in state.  Intuitively, a state machine is a bunch of possible states for an object, along with the transitions between those states.  You can imagine each state as a circle.  Each circle might have arrows leading out of it, representing transitions from that state, and might have arrows leading into it, representing transitions into that state.  For example, traffic lights have three states - red, yellow, and green.  They also have three transitions: red -> green, green -> yellow, yellow -> red.

[[image of traffic light state machine]]

Transition arrows are marked with symbols.  The machine(metaphorically) reads a symbol, looks at its current state, finds the transition arrow with the matching symbol, and moves to the state it points to.  For simplification purposes, we assume FSMs read symbols off a tape and automatically activate whatever transition they're supposed to.  There are two kinds of FSMs:

* Deterministic FSM: Deterministic FSMs are allowed one transition per symbol, and only allow transitions when they read a symbol.  In other words, if you know what your current state is and you know what the next symbol is, you always know where you're going to end up.
* Nondeterministic FSM: Nondeterministic FSMs are much more general.  Multiple transition arrows from the same state can have the same symbol, or transition on no symbol at all(generally represented as ε).

### Practical Uses: Regular Expressions

The most popular reason to use state machines is to implement regular expressions(regexes).  Each component of the regex represents a transition between two generic states.  There is also an accept state and a reject state.  The accept state is after the last symbol in the regular expression, and the reject state is where you go when nothing else matches.

[[image of simple regex state machine]]

## Turing Machines

Turing machines are one of the two fundamental models of computation.  They're basically the same as the state machine mentioned earlier, except they can modify the tape as they read it.  Conceptually, this gives them the ability to remember things they've done, which is all you need to calculate everything calculable.  No, really.  Your fancy new laptop is in a certain theoretical sense no better a computer than the Apple ][.  The other major model of computation, incidentally, is called the lambda calculus, and it is also Turing complete.  Any system of computation which is as powerful as a Turing machine is formally equivalent to it and this equivalence is called being Turing complete.  In other words, Turing machines are the most abstract and generic form of a computer.

Formally, a Turing machine consists of:

* A tape, broken up into cells, where each cell has a symbol in it.
* A read/write head, which reads the current cell and then optionally writes into it.
* A state machine, which determines what to do with the current symbol.

### Practical Uses: Accidental Turing Machines

Turing machines are theoretical constructs meant to provide a simple object used in writing formal proofs, not for practical use.  But they're really really simple, and if you relax the requirement that they move on their own there's a lot of stuff out there that's accidentally Turing complete.  Here's a short list:

* Magic: The Gathering
* DNA
* HTML5/CSS
* Minesweeper
* The `mov` assembly instruction
* Powerpoint

## Conclusion

We've covered some of the basic tools and ideas in computer science, moving from individual bits all the way up to Turing machines.  We also talked about abstraction as the fundamental tool of computer science, and about working with symbols without worrying abou what that symbol represents.

## Footnotes

[^1]: All abstractions are leaky.  This means that some of the information you've decided isn't important actually ends up being important.  You can't avoid leaky abstractions, so you also need to understand at least one level below whatever abstraction you're working with.  
[^2]: If you want to know whether the third bit is set `(1 << 3) & bitmap` will be 0 if it's unset and 1 if it's set.
