-- CREATE TABLE contoh untuk percobaan subqueries
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100)
);

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(200),
  department VARCHAR(100),
  price NUMERIC(10,2)
);

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  product_id INTEGER REFERENCES products(id),
  paid BOOLEAN
);
SELECT
  u.id,
  u.first_name,
  u.last_name,
  (
    SELECT COUNT(*)
    FROM orders o
    WHERE o.user_id = u.id
  ) AS orders_count
FROM users u;
SELECT
  u.id AS user_id,
  u.first_name,
  u.last_name,
  t.orders_count AS orders_count
FROM users u
LEFT JOIN (
  SELECT
    o.user_id,
    COUNT(*) AS orders_count
  FROM orders o
  GROUP BY o.user_id
) t ON t.user_id = u.id;
SELECT
  u.id,
  u.first_name,
  u.last_name
FROM users u
WHERE u.id IN (
  SELECT o.user_id
  FROM orders o
  WHERE o.paid = TRUE
);
SELECT
  u.id,
  u.first_name,
  u.last_name
FROM users u
WHERE EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.user_id = u.id
    AND o.paid = TRUE
);
SELECT
  u.id AS user_id,
  u.first_name,
  u.last_name,
  paid_t.paid_orders AS paid_orders
FROM users u
LEFT JOIN (
  SELECT
    o.user_id,
    COUNT(*) AS paid_orders
  FROM orders o
  WHERE o.paid = TRUE
  GROUP BY o.user_id
) paid_t ON paid_t.user_id = u.id;

