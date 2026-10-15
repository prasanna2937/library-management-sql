-- =====================================
-- LIBRARY MANAGEMENT SYSTEM (SQLite)
-- =====================================


-- PART 1: CREATE TABLES

DROP TABLE IF EXISTS Issued_Books;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Members;

CREATE TABLE Books (
    book_id   INTEGER PRIMARY KEY,
    title     TEXT NOT NULL,
    author    TEXT NOT NULL,
    category  TEXT NOT NULL,
    copies    INTEGER NOT NULL CHECK (copies >= 0)
);

CREATE TABLE Members (
    member_id INTEGER PRIMARY KEY,
    name      TEXT NOT NULL,
    email     TEXT UNIQUE,
    join_date TEXT NOT NULL
);

CREATE TABLE Issued_Books (
    issue_id    INTEGER PRIMARY KEY,
    book_id     INTEGER NOT NULL,
    member_id   INTEGER NOT NULL,
    issue_date  TEXT NOT NULL,
    due_date    TEXT NOT NULL,
    return_date TEXT,
    FOREIGN KEY (book_id)   REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);


-- PART 2: INSERT SAMPLE DATA

INSERT INTO Books VALUES
(1, 'Python Crash Course', 'Eric Matthes',       'Programming', 3),
(2, 'Clean Code',          'Robert C. Martin',   'Programming', 2),
(3, 'Wings of Fire',       'A.P.J. Abdul Kalam', 'Biography',   2),
(4, 'The Alchemist',       'Paulo Coelho',       'Fiction',     2),
(5, 'Atomic Habits',       'James Clear',        'Self-Help',   3);

INSERT INTO Members VALUES
(1, 'Ravi',   'ravi@example.com',   '2026-01-10'),
(2, 'Sita',   'sita@example.com',   '2026-02-15'),
(3, 'Kiran',  'kiran@example.com',  '2026-03-20'),
(4, 'Anitha', 'anitha@example.com', '2026-04-05');

INSERT INTO Issued_Books VALUES
(1, 1, 1, '2026-09-20', '2026-10-04', '2026-10-02'),
(2, 3, 1, '2026-09-25', '2026-10-09', NULL),
(3, 2, 2, '2026-10-05', '2026-10-19', NULL),
(4, 5, 2, '2026-09-10', '2026-09-24', '2026-09-22'),
(5, 1, 3, '2026-10-08', '2026-10-22', NULL),
(6, 4, 3, '2026-09-15', '2026-09-29', NULL),
(7, 1, 2, '2026-09-01', '2026-09-15', '2026-09-14');


-- PART 3: QUERIES

-- Query 1: All books
SELECT * FROM Books;

-- Query 2: Programming books only
SELECT title, author
FROM Books
WHERE category = 'Programming';

-- Query 3: Number of books issued by each member
SELECT m.name, COUNT(*) AS books_issued
FROM Issued_Books i
JOIN Members m ON i.member_id = m.member_id
GROUP BY m.name
ORDER BY books_issued DESC;

-- Query 4: Books currently issued (not yet returned)
SELECT m.name, b.title, i.issue_date, i.due_date
FROM Issued_Books i
JOIN Members m ON i.member_id = m.member_id
JOIN Books b   ON i.book_id   = b.book_id
WHERE i.return_date IS NULL;

-- Query 5: Overdue books
SELECT m.name, b.title, i.due_date,
       CAST(julianday('now') - julianday(i.due_date) AS INTEGER) AS days_late
FROM Issued_Books i
JOIN Members m ON i.member_id = m.member_id
JOIN Books b   ON i.book_id   = b.book_id
WHERE i.return_date IS NULL
  AND i.due_date < date('now');

-- Query 6: Most popular books
SELECT b.title, COUNT(*) AS times_issued
FROM Issued_Books i
JOIN Books b ON i.book_id = b.book_id
GROUP BY b.title
ORDER BY times_issued DESC
LIMIT 3;

-- Query 7: Members who never borrowed a book
SELECT m.name
FROM Members m
LEFT JOIN Issued_Books i ON m.member_id = i.member_id
WHERE i.issue_id IS NULL;

-- Query 8: Available copies per book (subquery)
SELECT b.title,
       b.copies AS total_copies,
       b.copies - (
           SELECT COUNT(*)
           FROM Issued_Books i
           WHERE i.book_id = b.book_id
             AND i.return_date IS NULL
       ) AS available
FROM Books b;

-- Query 9: Books count by category
SELECT category, COUNT(*) AS total_books, SUM(copies) AS total_copies
FROM Books
GROUP BY category;