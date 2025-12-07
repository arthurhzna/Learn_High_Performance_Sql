DROP TABLE IF EXISTS users_constraints;

CREATE TABLE users_constraints (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  age INTEGER NOT NULL DEFAULT 18 CHECK (age >= 0 AND age <= 150),
  balance NUMERIC(12,2) DEFAULT 0.00 NOT NULL CHECK (balance >= 0),
  status TEXT NOT NULL DEFAULT 'active',
  notes TEXT DEFAULT 'No notes'
);

INSERT INTO users_constraints (username, email, age, balance) VALUES ('alice', 'alice@example.com', 30, 100.00);

ALTER TABLE users_constraints
  ADD COLUMN created_at TIMESTAMPTZ NOT NULL DEFAULT now();

ALTER TABLE users_constraints
  ADD CONSTRAINT username_no_spaces CHECK (username NOT LIKE '% %');

/*Perintah untuk menambahkan constraint (aturan/pengecekan integritas) dengan nama ke tabel. 
Biasanya dipakai ALTER TABLE ... ADD CONSTRAINT constraint_name <tipe> (...) atau 
CHECK (... )*/

SELECT * FROM users_constraints;
