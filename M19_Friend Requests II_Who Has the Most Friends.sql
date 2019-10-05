/*
 In social network like Facebook or Twitter, people send friend requests and accept others requests as well.
Table request_accepted holds the data of friend acceptance, while requester_id and accepter_id both are the id of a person.

| requester_id | accepter_id | accept_date|
|--------------|-------------|------------|
| 1            | 2           | 2016_06-03 |
| 1            | 3           | 2016-06-08 |
| 2            | 3           | 2016-06-08 |
| 3            | 4           | 2016-06-09 |

Write a query to find the the people who has most friends and the most friends number. 
For the sample data above, the result is:

| id | num |
|----|-----|
| 3  | 3   |
Note:

!!! It is guaranteed there is only 1 people having the most friends. !!!
The friend request could only been accepted once, which mean there is no multiple records with the same requester_id and accepter_id value.
Explanation:
The person with id 3 is a friend of people 1, 2and 4, so he has 3 friends in total, which is the most number than any others.

Follow-up:
In the real world, multiple people could have the same most number of friends, can you find all these people in this case?
*/

DROP TABLE FACEBOOK;
CREATE TABLE FACEBOOK (REQUESTER_ID INT, ACCEPTER_ID INT, ACCEPT_DATE DATE);
TRUNCATE TABLE FACEBOOK;
INSERT ALL
INTO FACEBOOK (REQUESTER_ID, ACCEPTER_ID, ACCEPT_DATE) VALUES ('1', '2', TO_DATE('2016_06-03','YYYY-MM-DD'))
INTO FACEBOOK (REQUESTER_ID, ACCEPTER_ID, ACCEPT_DATE) VALUES ('1', '3', TO_DATE('2016_06-08','YYYY-MM-DD'))
INTO FACEBOOK (REQUESTER_ID, ACCEPTER_ID, ACCEPT_DATE) VALUES ('2', '3', TO_DATE('2016_06-08','YYYY-MM-DD'))
INTO FACEBOOK (REQUESTER_ID, ACCEPTER_ID, ACCEPT_DATE) VALUES ('3', '4', TO_DATE('2016_06-09','YYYY-MM-DD'))
SELECT * FROM DUAL;
SELECT * FROM FACEBOOK;

--UNION ALL: combine all the rows also with duplicate
SELECT REQUESTER_ID AS ID
FROM FACEBOOK
UNION ALL
SELECT ACCEPTER_ID
FROM FACEBOOK;

SELECT ID,
COUNT(ID) NUM,
RANK() OVER (ORDER BY COUNT(ID) DESC) RNK
FROM
(
	SELECT REQUESTER_ID AS ID
	FROM FACEBOOK
	UNION ALL
	SELECT ACCEPTER_ID
	FROM FACEBOOK
)
GROUP BY ID;

--[METHOD 1]
--Follow-up:
--In the real world, multiple people could have the same most number of friends, can you find all these people in this case? => SOLVED AS WELL
SELECT ID,
NUM
FROM
(
	SELECT ID,
	COUNT(ID) NUM,
	RANK() OVER (ORDER BY COUNT(ID) DESC) RNK
	FROM
	(
		SELECT REQUESTER_ID AS ID
		FROM FACEBOOK
		UNION ALL
		SELECT ACCEPTER_ID
		FROM FACEBOOK
	)
	GROUP BY ID
)
WHERE RNK=1;



--yulkyu said no keunbon [tree without a root!] [non-rootted tree]
SELECT --F.REQUESTER_ID,
MAX(COUNT(F.REQUESTER_ID)) NUM
FROM 
(
	SELECT REQUESTER_ID
	FROM FACEBOOK
	UNION ALL
	SELECT ACCEPTER_ID
	FROM FACEBOOK
) F
GROUP BY F.REQUESTER_ID;

SELECT F.REQUESTER_ID,
COUNT(F.REQUESTER_ID) NUM
FROM 
(
	SELECT REQUESTER_ID
	FROM FACEBOOK
	UNION ALL
	SELECT ACCEPTER_ID
	FROM FACEBOOK
) F
GROUP BY F.REQUESTER_ID;

--1) max(FF.num) not recommended
--2) use 'order by' inside and then 'where rownum=1' [recommended by yulkyu]
--3) 'order by' is done after the 'select', so I can use alias in order by!
--[METHOD 2]
SELECT FF.REQUESTER_ID,
FF.NUM
FROM 
(
	SELECT F.REQUESTER_ID,
	COUNT(F.REQUESTER_ID) NUM
	FROM 
	(
		SELECT REQUESTER_ID
		FROM FACEBOOK
		UNION ALL
		SELECT ACCEPTER_ID
		FROM FACEBOOK
	) F
	GROUP BY F.REQUESTER_ID
	ORDER BY NUM DESC --MAX WILL BE THE FIRST ROW
	
)FF
WHERE ROWNUM = 1; --SELECT THE MAX ROW
