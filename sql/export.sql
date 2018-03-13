use girlscouts;

SET GLOBAL group_concat_max_len = 1000000;

SELECT *
FROM dashboard
INTO OUTFILE '/tmp/dashboard.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT *
FROM contacts
INTO OUTFILE '/tmp/contacts.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT *
FROM troops
INTO OUTFILE '/tmp/troops.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


SELECT *
FROM leader_roster
INTO OUTFILE '/tmp/leader_roster.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
