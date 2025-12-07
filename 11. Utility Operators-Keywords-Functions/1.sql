SELECT
  id,
  name,
  price,
  weight,
  GREATEST(price, weight::numeric) AS greatest_value,
  LEAST(price, weight::numeric) AS least_value
FROM products;

SELECT
  id,
  name,
  GREATEST(price, weight::numeric, 100.00) AS max_of_three,
  LEAST(price, weight::numeric, 10.00) AS min_of_three
FROM products;

SELECT id, name, price, weight
FROM products
WHERE GREATEST(price, weight::numeric) > 500;

SELECT
  id,
  name,
  price,
  price * 0.9 AS discounted,
  GREATEST(price, price * 0.9) AS best_price_value
FROM products;

SELECT
  id,
  name,
  price,
  CASE
    WHEN price >= 900 THEN 'expensive'
    WHEN price >= 500 THEN 'mid'
    ELSE 'cheap'
  END AS price_category
FROM products;

SELECT
  id,
  name,
  price,
  CASE
    WHEN price IS NULL THEN 'unknown'
    WHEN price > (SELECT AVG(price) FROM products) THEN 'above_avg'
    ELSE 'below_avg'
  END AS price_vs_avg
FROM products;

SELECT
  id,
  name,
  price,
  CASE WHEN weight IS NULL THEN 'no_weight' ELSE 'has_weight' END AS weight_status
FROM products;

-- Examples using multiplication/division with GREATEST/LEAST
SELECT
  id,
  name,
  price,
  weight,
  GREATEST(30::numeric, weight * 2) AS greatest_30_mul_weight,
  LEAST(30::numeric, weight / 2.0) AS least_30_div_weight
FROM products;

SELECT
  id,
  name,
  price,
  weight,
  GREATEST(30, weight * price) AS greatest_30_mul_price,
  LEAST(30, weight / NULLIF(price,0)) AS least_30_div_price
FROM products;
