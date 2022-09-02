# Multi-Column Centering In CSS Grid

CSS Grid is the new hotness for website layout design.  It expands the concepts introduced in flexbox to two dimensions, and adds some other improvements.  One problem with Grid is that it limits you to just the grid dimensions.  I recently created a two-column grid, and needed to center something across both columns.  Now, you cannot tell grid something like "put this element centered on the line between these two columns."  So we have to fake it.

What I recommend is to create an element that spans every column using the `grid-column` property and then create a flexbox for that element with the text centered within the flexbox.

There is one gotcha to be aware of.  You can't yet say "This element spans all columns, however many there are," you have to specify the column numbers for the start and the end column.  If you tell it to span too many columns the grid will add extra columns to accommodate and it'll throw the whole layout off.

### The Code

Here's what it looks like, with a nicely centered title:

<style>
.grid {
    display: grid;
    grid-template-columns: repeat(2, mincontent);
    column-gap: 0.5em;
    justify-content: center;
    margin-bottom: 1em;
}

.title {
    grid-column: 1 / 3;
    display: flex;
    justify-content: center;
    font-weight: bold;
}
</style>
<div class="grid">
<div class="title">Title</div>
<div>Lorem</div>
<div>Ipsum</div>
<div>Dolor</div>
<div>Sic</div>
</div>

Here's the CSS:

```css
.grid {
    display: grid;
    grid-template-columns: repeat(2, mincontent);
    justify-content: center;
    column-gap: 0.5em; /*this is just to make it look better*/
}

.title {
    grid-column: 1 / 3;
    display: flex;
    justify-content: center;
    font-weight: bold; /* this is also just to make it look better*/
}
```

And here's the content:

```html
<div class="grid">
  <div class="title">Title</div>
  <div>Lorem</div>
  <div>Ipsum</div>
  <div>Dolor</div>
  <div>Sic</div>
</div>
```
