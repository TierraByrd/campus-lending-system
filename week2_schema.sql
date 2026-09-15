-- week2_schema.sql
-- Equipment Lending Desk schema (extended from Week 1)

DROP TABLE IF EXISTS Loan;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Item;

CREATE TABLE Student (
    StudentID   INTEGER PRIMARY KEY,
    FirstName   TEXT NOT NULL,
    LastName    TEXT NOT NULL,
    Email       TEXT NOT NULL UNIQUE
);

CREATE TABLE Item (
    ItemID      INTEGER PRIMARY KEY,
    ItemName    TEXT NOT NULL,
    Category    TEXT NOT NULL
);

CREATE TABLE Loan (
    LoanID        INTEGER PRIMARY KEY,
    StudentID     INTEGER NOT NULL,
    ItemID        INTEGER NOT NULL,
    CheckoutDate  TEXT NOT NULL,
    ReturnDate    TEXT,
    Status        TEXT NOT NULL CHECK (Status IN ('checked_out', 'returned')),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID)
);
