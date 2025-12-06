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

-- Semua pelanggan unik dari 2024 atau 2025 (email duplikat dihilangkan)
SELECT name, email FROM customers_2024
UNION
SELECT name, email FROM customers_2025;

-- Semua baris dari kedua tabel; jika ada yang sama, akan muncul berkali-kali
SELECT name, email FROM customers_2024
UNION ALL
SELECT name, email FROM customers_2025;

-- Pelanggan yang ada di 2024 dan juga di 2025 (berdasarkan kedua kolom yang dipilih)
SELECT email FROM customers_2024
INTERSECT
SELECT email FROM customers_2025;

-- Pelanggan yang ada di 2025 tapi TIDAK ada di 2024
SELECT email FROM customers_2025
EXCEPT
SELECT email FROM customers_2024;

-- User yang punya minimal satu order berbayar DAN juga punya minimal satu order tidak berbayar
SELECT user_id FROM orders WHERE paid = TRUE
INTERSECT
SELECT user_id FROM orders WHERE paid = FALSE;