CREATE TABLE exercise_logs
(
id INTEGER PRIMARY KEY AUTOINCREMENT,
type TEXT,
minutes INTEGER,
calories INTEGER,
heart_rate INTEGER
);

INSERT INTO exercise_logs(type, minutes, calories, heart_rate) VALUES
("biking", 30, 100, 110),
("biking", 10, 30, 105),
("dancing", 15, 200, 120),
("dancing", 15, 165, 120),
("tree climbing", 30, 70, 90),
("tree climbing", 25, 72, 80),
("rowing", 30, 70, 90),
("hiking", 60, 80, 85);

SELECT * FROM exercise_logs;

SELECT type, SUM(calories) FROM exercise_logs
GROUP BY type;

SELECT type, SUM(calories) AS total_calories FROM exercise_logs
GROUP BY type;

SELECT type, SUM(calories) AS total_calories FROM exercise_logs
WHERE calories > 150
GROUP BY type;

SELECT type, SUM(calories) AS total_calories FROM exercise_logs
GROUP BY type HAVING total_calories > 150;

SELECT type, AVG(calories) AS avg_calories FROM exercise_logs
GROUP BY type HAVING total_calories > 150; /* valores alterados para 50, 100, 80, 70 */

SELECT type FROM exercise_logs
GROUP BY type HAVING COUNT(*) >= 2;