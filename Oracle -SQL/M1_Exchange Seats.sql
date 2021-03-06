/*
Mary is a teacher in a middle school and she has a table seat storing students' names and their corresponding seat ids.
The column id is continuous increment.
Mary wants to change seats for the adjacent students.
 
Can you write a SQL query to output the result for Mary?
 

+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Abbot   |
|    2    | Doris   |
|    3    | Emerson |
|    4    | Green   |
|    5    | Jeames  |
+---------+---------+
For the sample input, the output is:
 

+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Doris   |
|    2    | Abbot   |
|    3    | Green   |
|    4    | Emerson |
|    5    | Jeames  |
+---------+---------+
Note:
If the number of students is odd, there is no need to change the last one's seat.
*/

CREATE TABLE SEAT(ID INT, STUDENT VARCHAR(255));
TRUNCATE TABLE SEAT;
INSERT ALL
INTO SEAT (ID, STUDENT) VALUES ('1', 'ABBOT')
INTO SEAT (ID, STUDENT) VALUES ('2', 'DORIS')
INTO SEAT (ID, STUDENT) VALUES ('3', 'EMERSON')
INTO SEAT (ID, STUDENT) VALUES ('4', 'GREEN')
INTO SEAT (ID, STUDENT) VALUES ('5', 'JEAMES')
SELECT * FROM DUAL;
SELECT * FROM SEAT;



--[METHOD 1]
--I CAN MAKE TEMP TABLE JUST FOR COUNT
SELECT (CASE 
	  WHEN MOD(ID,2)=0 
	  THEN ID-1
      WHEN MOD(ID,2)=1 AND ID=C.CNT 
      THEN ID --if last row
      WHEN MOD(ID,2)=1 AND ID != C.CNT 
      THEN ID+1
	  END) AS ID,
STUDENT
FROM SEAT S, 
(
	SELECT COUNT(ID) AS CNT
	FROM SEAT
) C
ORDER BY ID


--[METHOD 2]
SELECT ID, 
DECODE(M, 0, PRE_S, NVL(PST_S, STUDENT)) STUDENT --NVL IS NEEDED FOR THE LAST ODD NUM OF ROW
FROM 
(
	SELECT ID, 
	MOD(ID,2) M,
	STUDENT,
	LAG (STUDENT) OVER (ORDER BY ID) PRE_S,
	LEAD(STUDENT) OVER (ORDER BY ID) PST_S
	FROM SEAT
)
