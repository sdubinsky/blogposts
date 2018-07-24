# Autohighlighter Part Two: Bugfixes and Improvements

When we left off last time, I had what amounted to a minimal working example for taking a video of a bout, extracting the touches, and putting them together in a single video.  Now I'm going to turn it into a real program that other people can use.  Won't get there today, but I'm making progress.

## Classification
The first obvious step is to take the raw script and turn it into classes and methods.  This is much more of a dataflow problem than a hierarchical problem, so making it a class is a bit of a misnomer.  I'm going to use a functional design, and keep the class structure to avoid passing in a bunch of read-only variables to all the functions.  The basic flow is: cut frames > set size-dependent variables > compare frames > extract clips > concat into highlight reel.  Most of those steps were already present in the old code, I just extracted them into their own methods.

## Overlay Detection
One of the things I want to be able to do with this program is point it at a raw stream video and still get all the touches.  The problem with that is that I rely on the overlay being present.  What I had to do was detect the overlay.  I did that by precutting the Tissot ad in the middle, then comparing it to the current frame.  If it's not there, the code skips to the next frame.

## Batch Processing
I tried running the code on a full stream video, and it ran out of memory.  There were 26000 frames, and keeping them all in memory was too much for my poor machine.  The obvious solution is to only run some frames.  I chose 1000, pretty randomly.  So that part of the code is "load the next 1000 frames, check for touches."

## Improving ffmpeg Speed
That worked pretty well.  About half the video(~13000 frames out of ~26000) was dead air, and it skipped it.  And it clipped the first half successfully.  But the ffmpeg call to actually cut the clips were running intolerably slowly.  I've done enough googling to know that a big part of speeding up ffmpeg is cutting out seek times.  By doing separate calls to ffmpeg for every clip, I was making it reload the video into memory, seek through the first couple hours, and clip 20 seconds.

ffmpeg is a heck of a program, though, and has an option to specify multiple outputs.  Instead of calling the program anew for each clip, I can just specify all the clips in a single call.  That's simple string concatenation.  Specify the input before the loop, append the location duration and output file of each clip, and run it once.
