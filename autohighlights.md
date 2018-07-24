# Procedurally Generating Highlight Reels

This is a very boring discussion about making something very hype.  You have been warned.  I'm going to take you from video to a fully functioning highlight reel in a few easy steps, and a couple more moderately difficult ones.  We're assuming a unixlike here - it should work equally well on Mac or Linux.  Note that this is an early version of the code and the algorithm is subject to change.

## Overview
This whole concept is predicated on the fact that the FIE always uses more or less the same overlay.  The basic idea is we're going to isolate the bit that show the score, find out when it changes, and save the last 20 seconds as a highlight clip.  Then we're going to combine them back into a single file.  I'm going to assume that you already have the video.

## Tools
[ffmpeg](https://www.ffmpeg.org) is an amazing tool that does almost anything you want to any sort of streaming media.  I use it to add subtitles, combine songs into soundtracks, and add soundtracks to videos.  Here, we're going to use it to split the video into individual frames to prepare for the next step, to clip the actual highlight clips, and to merge them back together.

[ImageMagick](www.imagemagick.org) is to still images what ffmpeg is to streaming media.  You can do anything you want to an image.  What we're going to do here is barely scratching the surface.  We're also going to use a Ruby wrapper for ImageMagick called [Rmagick](https://rmagick.github.io).

The script itself is written in Ruby, and I shell out using `system` to make the ffmpeg calls.

## Step One: Split the Video
To extract the frames, we call `ffmpeg -i $video_file -vf 1 %08d.jpg`.

`-i $video_file` means use the $video_file path as the input file.  `-vf` means apply the following video filter.  `1` means get a frame every second. `%08d.jpg` describes the output files - number them starting at 1, with all names having 8 digits(0000001-99999999).

The second call is `ffmpeg -i $video_file -ss $clip_start_time -t $time output.mp4`.  `-ss` means "seek to this position in seconds," `-t` means "clip for the next $time seconds," and `output.mp4` is the name of the output file.

## Step Two: Extract The Touches
Here's the core code:
```ruby
frames = ImageList.new(*filenames)
score_count = 0
frames.each_cons 2 do |frame1, frame2|
  lnumber = frame1.crop(*lnumber_dms)
  lnumber2 = frame2.crop(*lnumber_dms)
  rnumber = frame1.crop(*rnumber_dms)
  rnumber2 = frame2.crop(*rnumber_dms)

  if lnumber.difference(lnumber2)[0] > 2500
    score_time = frame2.filename.split(".")[0].split("/")[1].to_i
    clip_start_time = score_time - 20

    system("ffmpeg -i \"#{ARGV[0]}\" -ss #{clip_start_time} -t 20 output/%02d.mp4" % score_count)

    score_count += 1
  end
end
```

Very briefly, we crop each frame down to just the scores, then compare them to see if it changes.  If it changes, we cut a 20-second clip ending four seconds after the touch, using another ffmpeg call: `ffmpeg -i $video_file -ss $clip_start_time -t $time output.mp4`.  `-ss` means "seek to this position in seconds," `-t` means "clip for the next $time seconds," and `output.mp4` is the name of the output file.  As before, we'll create numbered files, one for each touch.

## Step Three: Combine The Highlight Clips
Finally, we edit the clips back together to create a nice montage.  We're using ffmpeg again(of course), and the command is `ffmpeg -f concat -i files.txt -c copy highlight.mp4`.  `-f concat` tells it to concat the following clips into a video, and `-c copy` tells it to copy the videos instead of reencoding them.

`files.txt` has the list of clips in it you want to use.  Each line contains one clip, and each line looks like `file: 'path/to/clip'`.  One clip per line.

And we're done!
