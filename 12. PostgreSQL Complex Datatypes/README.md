# PostgreSQL Complex Datatypes

This document summarizes the complex / commonly used PostgreSQL data types with short guidance and examples. See `1.sql` in this folder for runnable CREATE/INSERT/SELECT examples.

## Numeric Types
- Integer types:
  - `SMALLINT` (range: -32768 to 32767)
  - `INTEGER` (range: -2147483648 to 2147483647)
  - `BIGINT` (range: -9223372036854775808 to 9223372036854775807)
- Serial (auto-increment): `SMALLSERIAL`, `SERIAL`, `BIGSERIAL` (mapped to respective integer sizes).
- Exact numeric:
  - `NUMERIC` / `DECIMAL` — arbitrary precision fixed-point. Use for monetary or exact calculations (precision and scale configurable).
- Floating point:
  - `REAL` (4-byte, ~6 digits precision)
  - `DOUBLE PRECISION` (8-byte, ~15 digits precision)
- `MONEY` type exists for locale-formatted monetary values but consider `NUMERIC` for most financial work.

## Character Types
- `CHAR(n)` — fixed-length; values are padded with spaces to length `n`.
- `VARCHAR(n)` — variable-length with a limit of `n` characters.
- `VARCHAR` (without `n`) and `TEXT` — store strings of any length; `TEXT` is generally used for long text fields.

## Boolean
- `BOOLEAN` accepts a variety of literals: `TRUE`, `FALSE`, `t`, `f`, `yes`, `no`, `1`, `0`, etc.
- `NULL` is allowed when the column permits it.

## Date / Time / Timestamp / Interval
- `DATE` — calendar date (ISO: `YYYY-MM-DD`). Accepts many human-friendly input formats.
- `TIME [WITHOUT TIME ZONE]` — time of day (no timezone).
- `TIME WITH TIME ZONE` (`timetz`) — time-of-day with timezone offset.
- `TIMESTAMP WITH TIME ZONE` (`timestamptz`) — absolute moment in time (store timezone-aware instants).
- `INTERVAL` — duration (e.g., `'1 day'`, `'1 day 1 hour 30 minutes'`).
- Use `to_char()` to format date/time/timestamp for presentation.

## Practical Guidance
- Use `SERIAL` / `BIGSERIAL` for auto-incrementing primary keys.
- Choose `NUMERIC` for exactness (money/accounting); use `DOUBLE PRECISION` for performance/range when a small rounding error is acceptable.
- Prefer `VARCHAR(n)` when you need to enforce a maximum length; use `TEXT` for free-form long text.
- Use `TIMESTAMPTZ` when storing instants that need correct handling across time zones.

## References
- PostgreSQL documentation: Data Types — https://www.postgresql.org/docs/current/datatype.html


---

For runnable examples and more details (ranges, formatting and casting examples), open `1.sql` in this directory.
