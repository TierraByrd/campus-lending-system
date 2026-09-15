-- week2_queries_optimized.sql
-- Optimized versions of the three baseline queries

-- Query 1 (optimized): Semester loan report
-- Only selects the columns the report actually uses, and filters to the
-- current semester (2025-08-25 onward) instead of pulling every loan ever made.
SELECT
    Student.FirstName,
    Student.LastName,
    Student.Email,
    Item.ItemName,
    Item.Category,
    Loan.CheckoutDate,
    Loan.ReturnDate
FROM Loan
JOIN Student ON Loan.StudentID = Student.StudentID
JOIN Item ON Loan.ItemID = Item.ItemID
WHERE Loan.CheckoutDate >= '2025-08-25';

-- Query 2 (optimized): Look up loans for one specific student
-- Same filter as baseline, but now StudentID has an index (idx_loan_student),
-- and we only select the columns a front-desk lookup actually needs.
SELECT LoanID, ItemID, CheckoutDate, ReturnDate, Status
FROM Loan
WHERE StudentID = 7;

-- Query 3 (optimized): Currently checked-out items
-- Same filter as baseline; Status now has an index (idx_loan_status), and we
-- drop columns the "what's out right now" report doesn't use.
SELECT LoanID, StudentID, ItemID, CheckoutDate
FROM Loan
WHERE Status = 'checked_out';

-- To compare the query plan for Query 2 after indexing (run manually):
-- EXPLAIN QUERY PLAN
-- SELECT LoanID, ItemID, CheckoutDate, ReturnDate, Status FROM Loan WHERE StudentID = 7;
