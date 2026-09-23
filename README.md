Analyzing and Improving Query Performance

## Scenario

This builds on the Week 1 Campus Equipment Lending Desk database (Student,
Item, Loan). The desk has been using it long enough that queries are
starting to feel slow, so this assignment looks at why a few common
queries do more work than they need to, and makes small changes (column
selection, filtering, indexes) to cut that work down. It also compares
querying a CSV file versus a Parquet file in DuckDB to see how storage
layout affects a simple analytics query.

## How to run this

1. Load the schema and data into SQLite:
   ```
   sqlite3 week2.db < week2_schema.sql
   sqlite3 week2.db < week2_data.sql
   ```
2. Run the baseline queries: `sqlite3 week2.db < week2_queries_baseline.sql`
3. Add the indexes: `sqlite3 week2.db < week2_indexes.sql`
4. Run the optimized queries: `sqlite3 week2.db < week2_queries_optimized.sql`
5. For the DuckDB part, run `week2_duckdb.sql` from the project root (so the
   `data/loan.csv` path resolves) using the DuckDB CLI or the DuckDB VS Code
   extension.

Sample data: 40 students, 34 items, 180 loans (130 from the current
semester, 50 from last semester, so filtering by semester actually changes
the result).

## Baseline queries (`week2_queries_baseline.sql`)

1. **Full semester report** — pulls every column from Loan, Student, and
   Item with no filtering. This is the same shape of query as the "slow
   report" from the Week 2 discussion.
2. **Student loan lookup** (`WHERE StudentID = 7`) — a front-desk style
   lookup for one student's loan history.
3. **Currently checked-out items** (`WHERE Status = 'checked_out'`) — a
   "what's out right now" report.

## Indexes (`week2_indexes.sql`)

- `idx_loan_student` on `Loan(StudentID)` — StudentID is used both as a
  filter (Query 2) and as the join key back to Student (Query 1), and it
  has high cardinality (40 different students), so it's a strong
  candidate for an index.
- `idx_loan_checkoutdate` on `Loan(CheckoutDate)` — needed to filter
  reports down to the current semester instead of scanning every loan
  ever made.
- `idx_loan_status` on `Loan(Status)` — added for the "checked out" report,
  though since Status only has two possible values it's a lower-cardinality
  column and helps less than the other two indexes.

## What changed between baseline and optimized

The baseline queries either used `SELECT *` or had no `WHERE` filter, so
SQLite's query plan showed a plain `SCAN Loan` for all three, meaning it
had to read every row in the table to answer the query. After adding the
indexes and rewriting the queries to filter early and select only the
columns each report actually needs, the plans changed to `SEARCH Loan
USING INDEX ...`, and the full semester report's result shrank from 180
rows to 130 once it only counted this semester's loans. On this small,
180-row table the timing difference was tiny (a fraction of a
millisecond), but the plan itself shows the database doing meaningfully
less work, which is what matters as the Loan table grows past laptop
scale. This lines up with the Week 2 idea that a full table scan means
touching every row, and an index gives the database a way to jump
straight to the rows that match instead.

## DuckDB: CSV vs Parquet

I ran the same category-count query against `data/loan.csv` and against
`data/loan.parquet` (converted from the same CSV with DuckDB's `COPY ...
TO ... (FORMAT PARQUET)`). Both returned identical results, but the query
plan for the CSV file used a `READ_CSV_AUTO` scan step, while the Parquet
file used a `PARQUET_SCAN` step with a noticeably lower row estimate,
since Parquet stores column metadata the engine can use before touching
the raw data. The Parquet file was also less than half the size of the
CSV on disk (about 5.6 KB vs 12.3 KB) even at only 180 rows, because
columnar storage groups repeated values, like the 8 item categories,
together and compresses them. That matches the Week 2 lesson on row vs
columnar storage: for a query that only touches a couple of columns
across many rows, a columnar format like Parquet has less data to read
and can compress it better than a row-based CSV.

Full plan output and timing numbers are in `week2_notes.txt`.

## AI assistance

AI assistance: I used Claude to remind me of the syntax for
`CREATE INDEX` and `EXPLAIN QUERY PLAN`, to get help rephrasing parts of
this README to make it clearer, to check my understanding of row vs
columnar storage against the Week 2 lesson, and to do a final pass over
my work to make sure I covered everything the assignment asked for
before submitting.
