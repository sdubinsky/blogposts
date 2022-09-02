# Using Postgresql's Union

The popular way to combine datasets in SQL is `join`, which combines data horizontally - the result set has the columns from both datasets.  However, I recently pushed an update to [The Fencing Database](https://fencingdatabase.com) that involved combining results from two queries vertically - I wanted to treat the results as one long result set.  The way to do this is an SQL command called `union`.

It's simple enough to use.  Here's the syntax:

```sql
SELECT col1 FROM table1
UNION
SELECT col2 FROM table2;
```

The only prerequisite is that both `SELECT` statements return the same number and type of columns.  Another thing to note is that this will do a true math-style union, and delete all duplicate rows.  If you want to include the duplicate rows, use `UNION ALL` instead of `UNION`.  The final gotcha is that the final column names will be whatever the names are in the first column.  For more, see [the docs](https://www.postgresqltutorial.com/postgresql-union/).
