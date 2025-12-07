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

-- Detailed numeric type ranges and notes
-- Integer types (no decimal point):
-- SMALLINT: -32768 to +32767
-- INTEGER: -2147483648 to +2147483647
-- BIGINT: -9223372036854775808 to +9223372036854775807

-- Serial (auto-increment) types (no decimal point):
-- SMALLSERIAL: 1 to 32767
-- SERIAL: 1 to 2147483647
-- BIGSERIAL: 1 to 9223372036854775807

-- Exact numeric / fixed-point:
-- NUMERIC / DECIMAL:
--   Maximum precision: 131072 digits before the decimal point;
--   Maximum scale (digits after decimal point): 16383
--   Use NUMERIC/DECIMAL when exactness is required (money, accounting, scientific with exact precision).

-- Floating-point / approximate numeric:
-- REAL (4-byte): approximately 1E-37 to 1E37 with ~6 decimal digits precision
-- DOUBLE PRECISION (8-byte): approximately 1E-307 to 1E308 with ~15 decimal digits precision
-- FLOAT is an alias that maps to REAL or DOUBLE PRECISION depending on precision specified.

-- Practical guidance:
-- - Use SERIAL/BIGSERIAL for auto-increment id columns.
-- - Use INTEGER/SMALLINT/BIGINT for whole numbers where exact integer values are needed.
-- - Use NUMERIC/DECIMAL for exact fixed-point arithmetic (financial data, precise measurements).
-- - Use REAL/DOUBLE PRECISION for approximate floating-point calculations where performance and range matter and exact decimal precision is not critical.
-- - Cast explicitly when mixing types to avoid unexpected implicit casts, e.g. value::numeric or value::double precision.

-- Character types summary
-- CHAR(n): fixed-length, menyimpan n karakter; jika nilai lebih pendek, PostgreSQL menambahkan spasi hingga panjang n.
-- VARCHAR(n): variable-length dengan batas n karakter; menyimpan hingga n karakter, akan menghasilkan error jika melebihi batas.
-- VARCHAR (tanpa n): alias untuk TEXT di PostgreSQL, menyimpan string dengan panjang berapa pun.
-- TEXT: menyimpan string dengan panjang tak terbatas (praktis), tidak ada batasan ukuran yang perlu ditentukan.
-- Perbandingan/perilaku:
-- - CHAR menyimpan padding spasi; saat dibandingkan, trailing spaces biasanya diabaikan pada banyak operasi, tetapi perilaku padding perlu diperhatikan.
-- - VARCHAR(n) berguna saat ingin membatasi panjang input (mis. kode pos, nomor telepon dengan format tertentu).
-- - TEXT cocok untuk konten panjang (mis. artikel, komentar) dan sering dipakai tanpa penalti kinerja signifikan pada PostgreSQL.
-- Rekomendasi praktis:
-- - Gunakan VARCHAR(n) jika Anda perlu menegakkan batas panjang pada kolom.
-- - Gunakan TEXT untuk teks panjang atau bila tidak ingin memikirkan batas panjang.
-- - Hindari CHAR kecuali Anda benar-benar membutuhkan fixed-length behavior (mis. pad output ke panjang tertentu).

-- Boolean types summary and examples
-- Accepted literals for TRUE: TRUE, 't', 'true', 'y', 'yes', 'on', '1'
-- Accepted literals for FALSE: FALSE, 'f', 'false', 'n', 'no', 'off', '0'
-- NULL is allowed as a boolean value when column permits NULL

CREATE TABLE boolean_examples (
  id SERIAL PRIMARY KEY,
  is_active BOOLEAN,
  is_verified BOOLEAN DEFAULT FALSE
);

INSERT INTO boolean_examples (is_active, is_verified) VALUES
  (TRUE, 't'),
  ('yes', FALSE),
  (1, 0),
  (NULL, 'f');

SELECT * FROM boolean_examples;

-- Examples of casting strings/numbers to boolean:
SELECT 't'::boolean AS t_bool, 'false'::boolean AS f_bool, '1'::boolean AS one_bool;

-- Example using boolean in WHERE:
SELECT id FROM boolean_examples WHERE is_active;

-- Date and Time types examples
-- DATE: stores a calendar date (YYYY-MM-DD). Accepts many input formats.
-- TIME [WITHOUT TIME ZONE]: stores time of day (no timezone), displayed as HH:MM:SS
-- TIME WITH TIME ZONE (timetz): stores time with timezone offset
-- TIMESTAMP WITH TIME ZONE (timestamptz): absolute point in time with zone info
-- INTERVAL: duration of time (e.g., '1 day', '1 day 1 minute 1 second')

CREATE TABLE datetime_examples (
  id SERIAL PRIMARY KEY,
  d DATE,
  t TIME,
  t_tz TIME WITH TIME ZONE,
  ts TIMESTAMP WITH TIME ZONE,
  iv INTERVAL
);

-- DATE examples (different input formats all parse to same date)
INSERT INTO datetime_examples (d) VALUES
  ('1980-11-20'),
  ('Nov-20-1980'),
  ('20-Nov-1980'),
  ('1980-November-20'),
  ('November 20, 1980');

-- TIME examples (without timezone)
INSERT INTO datetime_examples (t) VALUES
  ('01:23 AM'),
  ('05:23 PM'),
  ('20:34');

-- TIME WITH TIME ZONE examples (parse abbreviations or offsets)
INSERT INTO datetime_examples (t_tz) VALUES
  ('01:23 AM EST'),
  ('05:23 PM PST'),
  ('05:23 PM UTC');

-- TIMESTAMP WITH TIME ZONE example (parses local zone to absolute timestamptz)
INSERT INTO datetime_examples (ts) VALUES
  ('Nov-20-1980 05:23 PM PST');

-- INTERVAL examples
INSERT INTO datetime_examples (iv) VALUES
  ('1 day'),
  ('1 D'),
  ('1 D 1 M 1 S');

-- Select and show normalized outputs
SELECT id, d, to_char(d, 'DD Month YYYY') AS formatted_date FROM datetime_examples WHERE d IS NOT NULL;
SELECT id, t, to_char(t, 'HH24:MI') AS time_24h FROM datetime_examples WHERE t IS NOT NULL;
SELECT id, t_tz, to_char(t_tz, 'HH24:MIOF') AS time_with_zone FROM datetime_examples WHERE t_tz IS NOT NULL;
SELECT id, ts AT TIME ZONE 'UTC' AS ts_utc, ts FROM datetime_examples WHERE ts IS NOT NULL;
SELECT id, iv FROM datetime_examples WHERE iv IS NOT NULL;

-- Notes:
-- - DATE accepts many human-readable inputs; use ISO (YYYY-MM-DD) for portability.
-- - TIME stores time-of-day without timezone; TIMETZ includes offset information.
-- - TIMESTAMPTZ stores an absolute moment in time; displaying it can be shown in session timezone or converted with AT TIME ZONE.
-- - INTERVAL represents durations; input can use abbreviations (D, H, M, S) or words.
-- - Use functions like to_char() to format DATE/TIME/TIMESTAMP outputs.
