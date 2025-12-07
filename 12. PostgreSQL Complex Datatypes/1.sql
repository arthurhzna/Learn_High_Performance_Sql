-- PostgreSQL numeric data types examples

-- Integer types
CREATE TABLE numeric_examples_int (
  id SERIAL PRIMARY KEY,
  small_val SMALLINT,
  int_val INTEGER,
  big_val BIGINT
);

INSERT INTO numeric_examples_int (small_val, int_val, big_val)
VALUES (32767, 2147483647, 9223372036854775807);

SELECT * FROM numeric_examples_int;

-- Exact numeric: DECIMAL / NUMERIC
CREATE TABLE numeric_examples_exact (
  id SERIAL PRIMARY KEY,
  exact_default NUMERIC,         -- arbitrary precision
  exact_prec NUMERIC(10,2),      -- precision 10, scale 2
  decimal_col DECIMAL(8,3)       -- DECIMAL is alias of NUMERIC
);

INSERT INTO numeric_examples_exact (exact_default, exact_prec, decimal_col)
VALUES (12345678901234567890, 12345.67, 123.456);

SELECT exact_default, exact_prec, decimal_col FROM numeric_examples_exact;

-- Floating point types
CREATE TABLE numeric_examples_float (
  id SERIAL PRIMARY KEY,
  float4_col REAL,              -- 4-byte floating point
  float8_col DOUBLE PRECISION   -- 8-byte floating point
);

INSERT INTO numeric_examples_float (float4_col, float8_col)
VALUES (1.2345, 1.23456789012345);

SELECT * FROM numeric_examples_float;

-- Serial types (auto-increment integer types)
CREATE TABLE numeric_examples_serial (
  s_small SMALLSERIAL,   -- 1-byte/2-byte auto-inc (Postgres maps SMALLSERIAL to smallint sequence)
  s_int SERIAL,          -- 4-byte auto-increment
  s_big BIGSERIAL        -- 8-byte auto-increment
);

INSERT INTO numeric_examples_serial DEFAULT VALUES;
INSERT INTO numeric_examples_serial DEFAULT VALUES;
SELECT * FROM numeric_examples_serial;

-- Money type (locale-dependent formatting)
CREATE TABLE numeric_examples_money (
  id SERIAL PRIMARY KEY,
  price MONEY
);

INSERT INTO numeric_examples_money (price) VALUES ('$1234.56');
SELECT price, price::numeric FROM numeric_examples_money;

-- Notes / usage tips (examples):
-- 1) Use INTEGER/SMALLINT/BIGINT for whole numbers.
-- 2) Use NUMERIC/DECIMAL for exact fixed-point arithmetic (money/accounting).
-- 3) Use REAL/DOUBLE PRECISION for approximate floating-point where performance matters.
-- 4) Use SERIAL/BIGSERIAL for auto-incrementing keys (they create sequences).
-- 5) Cast explicitly when mixing types, e.g. (weight::numeric) or (price::double precision).

-- Numeric Types Fast Rules (summary from image)
-- 'id' column of any table -> mark the column as SERIAL / BIGSERIAL
-- Need to store a number without a decimal -> use INTEGER / SMALLINT / BIGINT
-- Need to store a number with a decimal and this data needs to be very accurate
--   -> use NUMERIC / DECIMAL (use for bank balances, grams of gold, accounting)
-- Need to store a number with a decimal and the decimal doesn't make a big difference
--   -> use DOUBLE PRECISION (use for kilograms of trash, liters of water, air pressure)
