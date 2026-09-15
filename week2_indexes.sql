-- week2_indexes.sql
-- Indexes added to support the most common lookups on Loan

-- StudentID: used constantly for "look up this student's loans" (Query 2),
-- and it's also the join key back to Student in Query 1.
CREATE INDEX idx_loan_student ON Loan (StudentID);

-- CheckoutDate: used to filter down to "this semester's loans" for reporting,
-- as recommended in the Week 2 discussion.
CREATE INDEX idx_loan_checkoutdate ON Loan (CheckoutDate);

-- Status: used by the "currently checked out" report (Query 3). Status only has
-- two possible values (checked_out / returned), so this index has low cardinality
-- and helps less than the other two, but it's included since that query runs often.
CREATE INDEX idx_loan_status ON Loan (Status);
