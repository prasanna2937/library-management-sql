# Library Management System (SQL)

A SQL project with three related tables and queries that answer common library questions.

## Database design
- Books (book_id, title, author, category, copies)
- Members (member_id, name, email, join_date)
- Issued_Books (issue_id, book_id, member_id, issue_date, due_date, return_date)

## Concepts used
- Primary keys, foreign keys and constraints (NOT NULL, UNIQUE, CHECK)
- INNER JOIN and LEFT JOIN
- GROUP BY, COUNT, SUM, ORDER BY, LIMIT
- Subqueries
- Date functions (overdue calculation)

## Queries included
- Books issued per member
- Books currently issued and not returned
- Overdue books with days late
- Most popular books
- Members who never borrowed a book
- Available copies per book
- Books count by category

## How to run
1. Open sqliteonline.com and select SQLite
2. Paste the code from library_management.sql
3. Click Run

## Built with
SQL (SQLite)
