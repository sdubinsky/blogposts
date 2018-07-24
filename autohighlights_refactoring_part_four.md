# Autohighlighter Part Four: Refactoring and Improvements

A lot has changed since the last update - refactoring, bugfixes, and new tech added.  In this post I'll go through it all.  It's finally in a state where it seems reliable and usable right off the bat.

## Overview

The original dev repo was cluttered and the amount of random crap in there made it difficult to work, so I ended up making a clean copy and doing the last round of updates there.  That made it a lot simpler.  Git is great.  I think I'm going to keep doing this - one repo for development, one for production.  For the first time, my reaction to a round of updates isn't "this has an acceptable amount of error" but "this actually seems to work really well."  During all of development I've been very proud of the fact that it works on a raw stream and not the individual bouts.  This round was the first time I seriously considered giving up on that, but thankfully I found ways to improve the image quality enough I didn't have to.

Individual classes have been refactored out, allowing for easier testing and further refactoring.  Direct image comparison has been replaced by OCR, which also lets us detect fencers' names.  The remaining image processing has been improved.  Image quality has been improved as well.  Small test videos have been generated, making for a quicker feedback loop.

## General Refactoring

Possibly the most important change is I found the ffmpeg command for extracting high-quality frames - I had to add `-q:v 1` before the output filename.  Image quality is the most important part of good OCR, so this was crucial.  I also disabled the ffmpeg safety checks to speed it up, since I know the videos are all the same type.

The other big change is that there's a separate class for frames and a separate class for individual scores.  The greater separation of concerns clarified and simplified the code, and made testing a lot easier.  For example, once I've generated the raw frames for a file, I can see how the OCR resolves for any individual frame without needing to start the whole program.

I started writing much more data to disk.  Instead of printing to stdout, it writes to a logfile.  it writes the scores to a separate file, the calls to a third, and the stats to a fourth.  I think printing to a logfile will speed it up by a fair amount, since it buffers and flushes after every batch instead of having to pause and write to screen every second.

I also added a check to frame.rb for a schedule overlay.  This just uses tesseract to see if the title is present.

## OCR - Tesseract

[Tesseract](https://github.com/tesseract-ocr/tesseract/ "tesseract") is an OCR library originally developed by HP.  I'm using version 3.05.02, but the latest is now version 4.0.  I'm using it to recognize both the scores and the fencers' names.  For the scores, I've limited it to just recognize digits.  It's a very hacky way of doing it - I'm shelling out to tesseract and saving the result in a variable.  One of my todos is to integrate the API directly.  This is much more reliable than trying to guess the threshold, and on top of that gives us extra info like the actual score and the fencers' names.  I installed it from brew, but full instructions are in the github repo.

## Image Processing - MiniMagick

[MiniMagick](https://github.com/minimagick/minimagick "minimagick") is a better version of RMagick, a library for interacting with ImageMagick.  It's faster and uses less memory.  The images are now in grayscale when passed to tesseract.

## Testing

I'm not sure how to save them, but I've finally got a plan for testing.  I'm going to generate small videos and run them, and check the result.  I can do the same with individual frames, now that I have a separate class for them.

## Conclusion

This system is now more or less production ready, and I'm reasonably confident that there are no more false positives or junk touches.  As far as this program goes, the only thing left to do is speed it up.  The first thing to look at is tesseract - just watching the program run, I can see it spends most of its time in tesseract.  The obvious thing to do is use the API so we don't have to write the images to disk every time, which will speed it up as well.

For the fencing database side, I'm going to upload these clips, see if the Heidenheim tags bug from last time is fixed, and rerun it on all current clips to update their tags and eliminate junk touches.  Then a couple more QOL improvements, and we should be good to go.
