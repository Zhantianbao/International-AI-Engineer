-- SQL Day06 — Transactions and Indexes
-- Database: ai_internship_tracker


-- =========================================================
-- 1. Transaction: COMMIT
-- =========================================================

CREATE TEMP TABLE transaction_demo (
    id INTEGER,
    note TEXT
);

BEGIN;

INSERT INTO transaction_demo (id, note)
VALUES (1, 'committed row');

SELECT *
FROM transaction_demo;

COMMIT;

-- The committed row remains visible.
SELECT *
FROM transaction_demo;


-- =========================================================
-- 2. Transaction: ROLLBACK
-- =========================================================

BEGIN;

INSERT INTO transaction_demo (id, note)
VALUES
    (2, 'first operation'),
    (3, 'second operation'),
    (4, 'third operation');

SELECT *
FROM transaction_demo;

ROLLBACK;

-- Rows 2, 3, and 4 were rolled back.
SELECT *
FROM transaction_demo;


-- =========================================================
-- 3. Transaction failure behavior
--
-- In PostgreSQL, an error inside an explicit transaction
-- puts the transaction into an aborted state.
--
-- Example used interactively:
--
-- BEGIN;
--
-- INSERT INTO transaction_demo (id, note)
-- VALUES (2, 'before error');
--
-- SELECT * FROM does_not_exist;
--
-- INSERT INTO transaction_demo (id, note)
-- VALUES (3, 'after error');
--
-- ROLLBACK;
-- =========================================================


-- =========================================================
-- 4. Inspect query plan without a custom title index
-- =========================================================

EXPLAIN
SELECT *
FROM positions
WHERE title = 'AI Engineer Intern';


-- =========================================================
-- 5. Create an index
-- =========================================================

CREATE INDEX idx_positions_title
ON positions (title);


-- =========================================================
-- 6. Inspect query plan with the index available
--
-- A very small table may still use Seq Scan because the
-- optimizer estimates that scanning the complete table
-- is cheaper than using the index.
-- =========================================================

EXPLAIN
SELECT *
FROM positions
WHERE title = 'AI Engineer Intern';


-- =========================================================
-- 7. Remove the learning index
-- =========================================================

DROP INDEX idx_positions_title;


-- =========================================================
-- 8. Role and privilege examples
--
-- These commands were practised interactively.
-- They remain commented so this file can be executed
-- without permanently changing database roles.
-- =========================================================

-- CREATE ROLE day06_reader NOLOGIN;

-- GRANT USAGE
-- ON SCHEMA public
-- TO day06_reader;

-- GRANT SELECT
-- ON TABLE positions
-- TO day06_reader;

-- SET ROLE day06_reader;

-- SELECT
--     position_id,
--     title
-- FROM positions
-- ORDER BY position_id;

-- RESET ROLE;

-- REVOKE SELECT
-- ON TABLE positions
-- FROM day06_reader;

-- REVOKE USAGE
-- ON SCHEMA public
-- FROM day06_reader;

-- DROP ROLE day06_reader;


-- =========================================================
-- 9. Useful PostgreSQL configuration queries
-- =========================================================

SHOW config_file;
SHOW data_directory;
SHOW port;
SHOW listen_addresses;
SHOW log_directory;
