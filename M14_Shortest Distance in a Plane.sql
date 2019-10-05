/*
 Table point_2d holds the coordinates (x,y) of some unique points (more than two) in a plane.
Write a query to find the shortest distance between these points rounded to 2 decimals.

| x  | y  |
|----|----|
| -1 | -1 |
| 0  | 0  |
| -1 | -2 |

The shortest distance is 1.00 from point (-1,-1) to (-1,-2). So the output should be:

| shortest |
|----------|
| 1.00     |
Note: The longest distance among all the points are less than 10000.
*/

CREATE TABLE POINTS (X_COORD INT, Y_COORD INT);
TRUNCATE TABLE POINTS;
INSERT ALL
INTO POINTS (X_COORD, Y_COORD) VALUES ('-1', '-1')
INTO POINTS (X_COORD, Y_COORD) VALUES ('0', '0')
INTO POINTS (X_COORD, Y_COORD) VALUES ('-1', '-2')
SELECT * FROM DUAL;
SELECT * FROM POINTS;

--strategy: first, all the combination should be done by cartesian product
-- second, should consider to exclude the distance between itself
SELECT P1.X_COORD X1,
P1.Y_COORD Y1,
P2.X_COORD X2,
P2.Y_COORD Y2
FROM POINTS P1, POINTS P2
WHERE P1.X_COORD != P2.X_COORD OR P1.Y_COORD != P2.Y_COORD; --OPPOSITE OF P1.X_COORD = P2.X_COORD AND P1.Y_COORD = P2.Y_COORD

SELECT P1.X_COORD X1,
P1.Y_COORD Y1,
P2.X_COORD X2,
P2.Y_COORD Y2,
POWER(P1.X_COORD - P2.X_COORD, 2) X1_X2,
POWER(P1.Y_COORD - P2.Y_COORD, 2) Y1_Y2,
POWER(P1.X_COORD - P2.X_COORD, 2) + POWER(P1.Y_COORD - P2.Y_COORD, 2) SUM,
SQRT(POWER(P1.X_COORD - P2.X_COORD, 2) + POWER(P1.Y_COORD - P2.Y_COORD, 2)) DISTANCE
FROM POINTS P1, POINTS P2
WHERE P1.X_COORD != P2.X_COORD OR P1.Y_COORD != P2.Y_COORD;

--FINAL
SELECT MIN(SQRT(POWER(P1.X_COORD - P2.X_COORD, 2) + POWER(P1.Y_COORD - P2.Y_COORD, 2))) SHORTEST
FROM POINTS P1, POINTS P2
WHERE P1.X_COORD != P2.X_COORD OR P1.Y_COORD != P2.Y_COORD; --OPPOSITE OF P1.X_COORD = P2.X_COORD AND P1.Y_COORD = P2.Y_COORD

