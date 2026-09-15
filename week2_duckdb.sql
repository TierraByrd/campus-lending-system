-- week2_duckdb.sql
-- DuckDB mini experiment: CSV vs Parquet
-- Run these with the DuckDB CLI (duckdb) or the DuckDB Python/VS Code extension,
-- from the project root so the relative "data/..." paths resolve.

-- 1. Query the CSV directly
SELECT ItemCategory, COUNT(*) AS loan_count
FROM 'data/loan.csv'
GROUP BY ItemCategory
ORDER BY ItemCategory;

-- 2. Convert the CSV to Parquet
COPY (SELECT * FROM 'data/loan.csv') TO 'data/loan.parquet' (FORMAT PARQUET);

-- 3. Run the same query against the Parquet file
SELECT ItemCategory, COUNT(*) AS loan_count
FROM 'data/loan.parquet'
GROUP BY ItemCategory
ORDER BY ItemCategory;

-- 4. Compare query plans (paste the output into week2_notes.txt)
EXPLAIN
SELECT ItemCategory, COUNT(*) AS loan_count
FROM 'data/loan.csv'
GROUP BY ItemCategory;

EXPLAIN
SELECT ItemCategory, COUNT(*) AS loan_count
FROM 'data/loan.parquet'
GROUP BY ItemCategory;

-- Observed results (see week2_notes.txt for full plan output):
-- Both queries return the same 8 rows (one per ItemCategory).
-- The CSV plan uses READ_CSV_AUTO and the Parquet plan uses PARQUET_SCAN.
-- The Parquet file was also less than half the size of the CSV on disk
-- (about 5.6 KB vs 12.3 KB for this 180-row sample), because Parquet stores
-- each column together and compresses repeated values like Category.
