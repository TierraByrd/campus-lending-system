-- week2_queries_baseline.sql
-- Baseline (unoptimized) queries — before any indexes or filtering improvements

-- Query 1: Full loan report (student name/email, item name/category, dates)
-- This is the "end of semester report" style query from the Week 2 discussion.
-- It selects every column from all three tables and does not filter by semester.
SELECT *
FROM Loan
JOIN Student ON Loan.StudentID = Student.StudentID
JOIN Item ON Loan.ItemID = Item.ItemID;

-- Query 2: Look up all loans for one specific student
-- Common "student history" lookup used by front-desk staff.
SELECT *
FROM Loan
WHERE StudentID = 7;

-- Query 3: List all currently checked-out items
-- Common "what's out right now" report.
SELECT *
FROM Loan
WHERE Status = 'checked_out';

-- To see the query plan for Query 2 (run this manually in the sqlite3 shell):
-- EXPLAIN QUERY PLAN
-- SELECT * FROM Loan WHERE StudentID = 7;
