SELECT
  u.id AS user_id,
  u.username,
  COUNT(p.id) AS photo_count
FROM users u
JOIN photos p ON p.user_id = u.id
WHERE p.url IS NOT NULL
GROUP BY u.id, u.username;

SELECT
  p.id AS photo_id,
  p.url,
  COUNT(c.id) AS comments_count
FROM photos p
LEFT JOIN comments c ON c.photo_id = p.id
GROUP BY p.id, p.url
HAVING COUNT(c.id) >= 5;

SELECT
  u.id AS user_id,
  u.username,
  COUNT(c.id) AS self_comment_count
FROM users u
JOIN photos p ON p.user_id = u.id
JOIN comments c ON c.photo_id = p.id AND c.user_id = u.id
WHERE c.contents IS NOT NULL
GROUP BY u.id, u.username
HAVING COUNT(c.id) > 0;
