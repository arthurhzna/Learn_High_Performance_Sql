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

SELECT
  (SELECT MAX(price) FROM phones) AS max_price,
  (SELECT MIN(price) FROM phones) AS min_price,
  (SELECT AVG(price) FROM phones) AS avg_price;


SELECT (
  SELECT MAX(price) FROM products
) / (
  SELECT MIN(price) FROM products
) AS price_ratio;

SELECT name, department, price
FROM products AS p1
WHERE p1.price = (
  SELECT MAX(price)
  FROM products AS p2
  WHERE p1.department = p2.department
);


SELECT p1.name,
(
  SELECT COUNT(*)
  FROM orders AS o1
  WHERE o1.product_id = p1.id
) AS num_orders
FROM products AS p1;


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

SELECT *
FROM table1 t1
WHERE t1.a > (SELECT MAX(a) FROM table2);

SELECT *
FROM table1 t1
WHERE t1.a > ALL (SELECT a FROM table2);

SELECT *
FROM table1 t1
WHERE t1.a > SOME (SELECT a FROM table2);
