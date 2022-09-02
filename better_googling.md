# Better Googling

Standard advice for a new programmer is "Google is your best friend."  And it's true!  All the information you could ever want is in google, along with all the information you would have wanted if you were asking the question five years ago, or fifteen.  How can you filter out the old, useless, out-of-date results?  You can learn how to write a better query, but that will only get you so far.  Here's how you can fix the problem for real, painlessly and automatically.

## The Problem

Google's search algorithm is based around returning the best result for a general audience, but as a programmer you have somewhat different requirements and more specialized needs.  For example, the first page of results for a query like "css align vertically and horizontally" includes information from as early as 2014.

The correct solution for aligning elements both horizontally and vertically is to use CSS Grid, which is like flexbox on steroids(flexbox is how you align content on a single row or column).  CSS Grid was added to Chrome in early 2017.  That StackOverflow answer from 2014 was likely accurate when it was written, but no longer - all it's doing now is polluting your search results.  I don't mean to pick on CSS, either.  Most languages and most questions will run into similar issues, since programming is a fast-moving field.

## The Solution

Depending on your familiarity with Google, you already know that you can limit your search results to a specific time frame.  For most programming questions, I've found that limiting the search to the past year is the best balance between information quality and quantity, but clicking the filter buttons every time is frankly annoying.  Here's how to set your default search to google year.

### Chrome

In the Chrome search engine settings(put `chrome://settings/searchEngines` in the address bar), either click edit on the default google search engine or click Add.  If you click "add", give it a name(mine is google year), a keyword(can be anything), and the following string: `google.com/search?q=%s&tbs=qdr:y`.  The `%s` means "put the search string here" and the `tbs=qdr:y` is what tells Google to limit it to the past year.  Save it, and set it as the default.  If you edited the default engine, replace the query URL with the above string.  Now, all your omnibar searches will automatically be limited to the past year!

### Firefox

You can't do it quite as automatically on firefox as you can on Chrome, but you can get close using bookmarks.  [Follow this link](https://google.com/search?q=shalom+dubinsky&tbs=qdr:y)(it's a google search for me).  Right-click on the search bar and choose "set a keyword for this search".  I use 'g', and when I want to do a google year search I type 'g' and then whatever I'm searching for.

And that's all there is to it!  It's an absolute lifesaver.  I've gotten so used to it that it's jarring whenever I use a different computer and all my results are worthless.
