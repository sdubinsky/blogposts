# Four Common Problems With CSVs

Comma-separated value files, or CSVs, are the default file format.  There is no formal csv spec the way there is for JSON - you have to deal with whatever people come up with to separate their values.  Programmers everywhere curse these files, since anything that can go wrong with them usually does.  

I once had a job where I had to manually pull a CSV file from an FTP server and process it into a different CSV file.  It was awful, although I made a lot of progress on a better [commandline shell](https://github.com/sdubinsky/pysftp-shell) for sftp transfers.  Here are four common problems I ran into, then and at other times, and how to deal with them.

## Headers

Sometimes, CSV files tell you what's in them.  Sometimes, they don't.  Sometimes, they only kind of do and the header line doesn't line up evenly with the rest of the data.  If you're trying to programmatically read a CSV file, it's important to check whether or not the file has a header line.  If it does, make sure you skip it during processing, or delete it before you start processing the file.  If you have to deal with them programmatically, it's just one more thing to check for.

## Escape Characters

"The medium is the message" is one of the most profound statements you can make about programming and computer science, and has some very deep philosophical implications.  For more, read Douglas Hofstadter's _The Eternal Golden Braid_.  Here, it just means that while you're using commas to mean "this is a different value," sometimes the values themselves also contain commas.  There are a couple different ways to handle this.  The most common solution is to enclose any value that contains a comma in quotes, but not all parsers recognize this, and some need to have the option explicitly passed to them.

## Bad CSV Viewers

By default, CSV files on Windows open in Excel.  But Excel, as excellent a program as it is, isn't a CSV viewer, it's a tabular data viewer.  This means that it tries to guess what your data really is, and it tries to display it more nicely.  This usually pops up two different ways.  The first is that a lot of times, it'll think something is a date, and reformat it as such, even though it really isn't.  The second is that it'll try to make numbers look nice.  Any trailing zeros are deleted, and any very long numbers are formatted in scientific notation.  There is an option to change this, but you have to reset it for every file, and you have to know that it's happening first.

## Wrong Delimiter

Remember when I said that there was no formal CSV spec?  Yeah.  The delimiter is the character used for marking the boundaries of values.  Most commonly, it's a comma, hence the name.  Very frequently, it's a semicolon, or a tab, or whatever else the file creator thinks makes sense.  If your file isn't getting processed properly, check to make sure you're using the right delimiter.

There are lots more possible problems, of course, but these are four of the most common.
