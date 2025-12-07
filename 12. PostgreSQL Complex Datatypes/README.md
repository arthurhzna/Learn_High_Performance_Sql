# PostgreSQL Complex Data Types — Selection Rules and Guidance

This README explains how to choose PostgreSQL data types for common cases, with rules of thumb, examples, and practical tips. For runnable SQL examples, see `1.sql` in this folder.

## Decision Checklist
1. Is the value an integer or a decimal? Choose integer types for whole numbers, numeric/floating for decimals.
2. Do you need exact numeric precision (e.g., money/accounting)? Use `NUMERIC`/`DECIMAL`.
3. Do you need high range and performance where small rounding error is acceptable (scientific)? Consider `DOUBLE PRECISION` or `REAL`.
4. Do you need to enforce a maximum text length? Use `VARCHAR(n)`; otherwise use `TEXT`.
5. Do timestamps need timezone-aware behavior? Use `TIMESTAMPTZ` for absolute instants.
6. Are values limited to a small fixed set? Consider `ENUM` or a reference table.
7. Is data semi-structured (JSON)? Use `JSONB` for efficient querying and indexing.
8. Need auto-incrementing identifiers? Use `SERIAL`/`BIGSERIAL` or `GENERATED ... AS IDENTITY`.
9. Will the column be indexed or used in joins/filters? Prefer compact, index-friendly types.
10. Decide `NULL` vs `NOT NULL`, defaults, and constraints early (e.g., `CHECK`, `UNIQUE`).

## Numeric Types — Rules
- Integer types:
  - `SMALLINT`: -32768 .. 32767
  - `INTEGER`: -2147483648 .. 2147483647
  - `BIGINT`: -9223372036854775808 .. 9223372036854775807
  Choose the smallest type that safely holds your range to save storage and improve performance.

- Exact numeric:
  - `NUMERIC(p,s)` / `DECIMAL(p,s)` — arbitrary-precision fixed-point. Use for monetary and accounting data.
  - Example: `NUMERIC(12,2)` stores values up to 9999999999.99.

- Floating point:
  - `REAL` (4-byte, ~6 digits precision)
  - `DOUBLE PRECISION` (8-byte, ~15 digits precision)
  Use floating types when performance and range matter and small rounding errors are acceptable.

- Auto-increment:
  - `SMALLSERIAL`, `SERIAL`, `BIGSERIAL` map to sequences of respective integer sizes (or prefer `GENERATED AS IDENTITY`).

- Avoid `MONEY` for critical financial logic; prefer `NUMERIC` for exact calculations.

## Character / Text Types
- `CHAR(n)`: fixed-length; stored padded with spaces to length `n`. Use only when fixed-width is required.
- `VARCHAR(n)`: variable-length with enforced maximum `n`. Good for codes, formatted fields.
- `TEXT` / `VARCHAR` (no length): unbounded text. Use for long or free-form content.
- Use `VARCHAR(n)` to enforce input length in the database; use `TEXT` when no limit is required.

## Boolean
- `BOOLEAN` stores TRUE/FALSE; accepted input literals include `TRUE`, `FALSE`, `t`, `f`, `1`, `0`, `yes`, `no`.
- Define sensible `DEFAULT` and `NOT NULL` when applicable.

## Date & Time
- `DATE`: stores a calendar date (use ISO `YYYY-MM-DD` for portability).
- `TIME [WITHOUT TIME ZONE]`: time of day without timezone.
- `TIME WITH TIME ZONE` (`timetz`): time-of-day with offset.
- `TIMESTAMP WITH TIME ZONE` (`timestamptz`): recommended for event timestamps — stores absolute instants.
- `TIMESTAMP WITHOUT TIME ZONE`: use for local times that should not shift across time zones.
- `INTERVAL`: durations such as `'1 day'`, `'1 day 1 hour 1 minute'`.
- Use `to_char()` and `AT TIME ZONE` to format or convert timestamps.

## JSONB & Arrays
- `JSONB` is preferred for semi-structured data that you will query/index.
- `JSON` stores raw JSON text; `JSONB` is binary-optimized for queries.
- Use SQL arrays (`TEXT[]`, `INTEGER[]`) for small lists; for larger or relational lists prefer normalized child tables.

## Other types
- `UUID`: use for globally unique identifiers. Generate with `gen_random_uuid()` or `uuid_generate_v4()`.
- `BYTEA`: binary data; use object storage for large files.
- `ENUM`: convenient for small fixed value sets, but altering enums requires `ALTER TYPE`.

## Indexing & Storage Considerations
- Smaller column sizes make indexes and I/O faster. Don’t oversize columns.
- Indexing long text fields can be expensive; use GIN/GIN-trgm or materialized columns for full-text search.
- Numeric joins: prefer integer types over text for better performance.

## Constraints & Validation
- Use `NOT NULL` where appropriate.
- Use `CHECK` constraints for value constraints (e.g., `CHECK (age >= 0)`).
- Use `UNIQUE`, `PRIMARY KEY`, and `REFERENCES` for integrity.

## Quick Decision Examples
- Auto-increment id → `SERIAL`/`BIGSERIAL` or `BIGINT` PK
- Money/accounting → `NUMERIC(p,s)`
- Scientific measurements → `DOUBLE PRECISION`
- Long text → `TEXT`
- Bounded fields (email, postal code) → `VARCHAR(n)`
- Event timestamps → `TIMESTAMPTZ`
- Semi-structured → `JSONB`

## Example schema recommendation
```sql
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(320) NOT NULL UNIQUE,
  full_name TEXT,
  balance NUMERIC(12,2) NOT NULL DEFAULT 0.00,
  metadata JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

## Performance tips
- Avoid unnecessarily large VARCHAR when indexing. Set realistic maximum lengths.
- For joins, prefer integer keys over textual keys where possible.
- Use partial/indexed expressions for complex query patterns.

## References
- PostgreSQL documentation — Data Types: https://www.postgresql.org/docs/current/datatype.html

---

If you want I can also add a storage-size summary table per type or a printable checklist version.
