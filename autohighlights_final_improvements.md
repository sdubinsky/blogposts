# Autohighlighter Part Three: More Improvements

Last week, I released the first video created using this program - you can find it [here](https://www.youtube.com/watch?v=oeIhM2szl9k).  I had gotten bored of fixing minor bugs, so I made a reddit post giving myself a deadline and finished up the last few things.  I hit a few dead ends and made a few wrong turns as well - I'm including them here for completeness' sake.  Much like the last post, this is a mostly-unconnected series of bugs.

## Duplicate Touch Detection

I originally tested using the main stream, which focused mostly on one piste but switched if a bout wasn't going on.  I assumed all streams would be the same, so I investigated ways to detect duplicate touches.  I ended up settling on perceptual hashing, which more or less measures the difference between two streams.  It seemed to work pretty well, but I ended up not needing it because the individual piste streams stayed on one piste.

## Double Touch Detection

The code counts touches by when the score changes, but when double touches are scored they generally don't update the score within the same frame, so it was outputting the same clip twice for double touches.  I added a bit that said if a touch was detected within a certain time period, count it as a double and don't save the clip.  I also needed to check for doubles within the same frame.

## Frame Generation

During development, I generated the frames once and just commented out that line of code.  For release, I wanted a way to have the code itself detect whether there were already raw frames.  Easy enough, just check if the directory is empty.  I also added a bit to create the directory if it doesn't exist.

## ffmpeg Calls

Another thing I skipped during development was actually calling ffmpeg, since it's far and away the slowest part of the thing.  What I did instead was write them to a file, where I could manually inspect them and look for anything obviously wrong.

When I initially tried to automatically run them, it didn't work.  From a shell, I could call `bash ffmpeg_calls.txt` and it would work fine, but calling `system('bash ffmpeg_calls.txt')` would actually open a new bash process.  I couldn't figure it out at the time(and someone gave me a better solution) but it turns out that the `system` call itself runs whatever you give it as a bash script, and when you run `bash` from a shell you get a new shell. So in essence I was running `bash bash ffmpeg_calls.txt`.

The correct solution I got online.  Someone told me to stop writing the calls to a text, and just build the command directly.  Now I save the calls to an array, and join the array with '&&' and call `system` with that.  Faster and simpler, because no IO, and it works.

## Thresholding
One of the hardest parts of this was detecting when the number changed.  Since it's looking at such a small portion of the frame, there aren't a lot of pixels different between similar numbers like 5 and 6.  It got to the point where I had to declare it unreliable for images less than 1280x720.  I tried increasing several variations on thresholding, and ended up just going with what I had.  A strange part was that it would detect differences even if the number itself didn't change.

The one part I wanted to do that I actually did give up on was detecting when the score reset, if the overlay didn't go away.  I might implement OCR for numbers later, but I didn't have time for now.  So there's a new clip for some bouts that's just a clip of the score resetting to 0.

If a touch is awarded via red card, it shows the card being awarded but not the action. If a touch is awarded then revoked, it clips the initial award and also the recovation.  I consider detecting these outside the scope of the project.

## Conclusion

This went over way better than I expected.  I even got a message that the US national team wants to see more, since they have to study all the video anyway.  I learned a lot about ffmpeg(wonderful tool) and I consider myself competent in it now.  It's in a reasonably stable state, and I'll probably run it a few more times and see where the pain points are, but it's out there for anyone to use.  It's my first open source project that I actually published anything from and let people see, which is pretty cool.  I'm hoping with all these videos I'll see more content creation coming out of the fencing community.  It's pretty backwards, especially compared to the esports communities.  Someone starting a top 10 touches channel would be amazing.
