# Autohighlighter Part Four: Refactoring and Improvements

A lot has changed since the last update - refactoring, bugfixes, and new tech added.  In this post I'll go through it all.  It's finally in a state where it seems reliable and usable right off the bat.  You ought to be able to download it, install the dependencies, and run it on whatever files you want.

## Overview

The original dev repo was cluttered and the amount of random crap in there made it difficult to work, so I ended up making a clean copy and doing the last round of updates there.  That made it a lot simpler.  Git is great.  I think I'm going to keep doing this - one repo for development, one for production.  For the first time, my reaction to a round of updates isn't "this has an acceptable amount of error" but "this actually seems to work really well, and I can't find any obvious errors."  During all of development I've been very proud of the fact that it works on a raw stream and not the individual bouts.  Thanks to the overlay, this round was the first time I seriously considered giving up on that.  Thankfully I found ways to improve the image quality enough I didn't have to.

Individual classes have been refactored out, allowing for easier testing and further refactoring.  Direct image comparison has been replaced by OCR, which also lets us detect fencers' names.  The remaining image processing has been improved.  Image quality has been improved as well.  Small test videos have been generated, making for a quicker feedback loop.

## General Refactoring

Possibly the most important change is that I found the ffmpeg command for extracting high-quality frames - I had to add `-q:v 1` in the video filter section.  Image quality is the most important part of good OCR, so this was crucial.  I also disabled the ffmpeg safety checks to speed it up, since I know the videos are all the same type.

The other big change is that there's a separate class for frames and a separate class for individual scores.  The greater separation of concerns clarified and simplified the code, and made testing a lot easier.  For example, once I've generated the raw frames for a file, I can see how the OCR resolves for any individual frame without needing to start the whole program.

I started writing much more data to disk.  Instead of printing to stdout, it writes to a logfile.  it writes the scores to a separate file, the calls to a third, and the stats to a fourth.  I think printing to a logfile will speed it up by a fair amount, since it buffers and flushes after every batch instead of having to pause and write to screen every second.

I also added a check to frame.rb for a schedule overlay.  This just uses tesseract to see if the title is present.

Finally, I spent a few days working to speed things up, and managed to shorten a single run from ~26 hours to ~6.

## OCR - Tesseract

[Tesseract](https://github.com/tesseract-ocr/tesseract/ "tesseract") is an OCR library originally developed by HP.  I'm using version 3.05.02, but the latest is now version 4.0.  I'm using it to recognize both the scores and the fencers' names.  For the scores, I've limited it to just recognize digits.  It's a very hacky way of doing it - I'm shelling out to tesseract and saving the result in a variable.  One of my todos is to integrate the API directly.  This is much more reliable than trying to guess the threshold, and on top of that gives us extra info like the actual score and the fencers' names.  I installed it from brew, but full instructions are in the github repo.

## Image Processing - MiniMagick

[MiniMagick](https://github.com/minimagick/minimagick "minimagick") is a better version of RMagick, a library for interacting with ImageMagick.  It's faster and uses less memory.  I also set it to put the images in grayscale when passed to tesseract, because it makes the OCR more reliable.  The only problem with minimagick is that it requires me to write all the images to file, which I'll talk about more later.  Let's just say, thank God I have an SSD.

## Speedups

I did a full run of the Heidenheim 2018 streams, and it worked really well but took over a day per stream.  This was unacceptable, and in fact I believe it was somewhat slower than previously

## Future Work

First, I need to set up a real test environment.  I won't be able to add it to git because of the media files required, but it's absolutely crucial.  I'm going to test that it detects invalid frames, valid frames, detects touches with pairs of frames, and so on.  Refactoring the code was absolutely crucial for this.

Second, I should build a prod mode and a debug mode.  The prod mode will reuse the same logfiles and prefix for all files, exporting a single highlights.mp4 file at the end, and the debug mode will use separate prefixes.

Finally, I'd like to work on usability.  To set it up for a new tournament, I have to go in and manually verify that the score and name locations are accurate.  I'd like to extract that and either make an easy tool or detect it automatically.  The end goal is you download the code, download the video files, and run it.

## Conclusion

This system is now more or less production ready, and I'm reasonably confident that there are no more false positives or junk touches.  I'm very happy with it and proud of what I've accomplished.  I think it's good enough now that I can just start processing all the old tournaments one after another.  It's time to focus on the website again.  Maybe I can even get a combo video out!
