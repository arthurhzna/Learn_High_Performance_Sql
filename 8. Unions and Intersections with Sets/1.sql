CREATE TABLE customers_2024 (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(200)
);

CREATE TABLE customers_2025 (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(200)
);

INSERT INTO customers_2024 (name, email) VALUES
  ('Ayu', 'ayu@example.com'),
  ('Budi', 'budi@example.com'),
  ('Citra', 'citra@example.com');

INSERT INTO customers_2025 (name, email) VALUES
  ('Budi', 'budi@example.com'),
  ('Dedi', 'dedi@example.com'),
  ('Eka', 'eka@example.com');

SELECT name, email FROM customers_2024
UNION
SELECT name, email FROM customers_2025;

SELECT name, email FROM customers_2024
UNION ALL
SELECT name, email FROM customers_2025;

SELECT email FROM customers_2024
INTERSECT
SELECT email FROM customers_2025;

SELECT email FROM customers_2025
EXCEPT
SELECT email FROM customers_2024;

SELECT user_id FROM orders WHERE paid = TRUE
INTERSECT
SELECT user_id FROM orders WHERE paid = FALSE;