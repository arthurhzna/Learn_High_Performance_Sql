CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  username VARCHAR(30)
);

CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  url VARCHAR(200),
  user_id INTEGER REFERENCES users(id)
);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  contents VARCHAR(240),
  user_id INTEGER REFERENCES users(id),
  post_id INTEGER REFERENCES posts(id)
);

CREATE TABLE likes (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP,
  user_id INTEGER REFERENCES users(id),
  comment_id INTEGER REFERENCES comments(id),
  post_id INTEGER REFERENCES posts(id)
);
