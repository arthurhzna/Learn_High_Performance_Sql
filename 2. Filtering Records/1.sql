DROP TABLE cities
-- 
CREATE TABLE cities (
	name VARCHAR(50),
	country VARCHAR(50),
	population INTEGER,
	area INTEGER
)

INSERT INTO cities (name, country, population, area)
VALUES ('Tokyo', 'Japan', 38505000, 8223);

INSERT INTO cities (name, country, population, area)
VALUES 
	('Delhi', 'India', 28125000, 2240),
  ('Shanghai', 'China', 22125000, 4015),
  ('Sao Paulo', 'Brazil', 20935000, 3043);

SELECT name, area FROM cities;	

SELECT name || ', ' || country AS location FROM cities

SELECT name, area FROM cities WHERE area > 4000

SELECT name, area FROM cities WHERE name IN ('Delhi', 'Shanghai') AND area = 4015

SELECT name, population / area AS population_density WHERE population / area > 6000;

DELETE FROM cities 
WHERE name = 'Tokyo';

