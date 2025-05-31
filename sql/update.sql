use girlscouts;

SET GLOBAL group_concat_max_len = 10000000;
SET session group_concat_max_len=10000000;

update roster set troop_id=replace(troop_id, "Troop", "");

UPDATE roster SET grade = trim(grade);
UPDATE roster SET grade = TRIM(TRAILING '\\' FROM (REPLACE(REPLACE(REPLACE(grade, '\n', ' '), '\r', ' '), '\\', ' ')));
UPDATE roster SET grade = trim(grade);

  
drop table if exists troops;
create table troops (
`id` VARCHAR(255) NOT NULL,
`girls_early_birded` INT DEFAULT NULL,
`level` VARCHAR(255),
`leaders` TEXT,
`leader_emails` TEXT,
`number_leaders` VARCHAR(20),
`girls` TEXT,
`number_girls` VARCHAR(20),
`has_first_aider` BOOLEAN,
`has_money_manager` BOOLEAN,
`has_fall_product` BOOLEAN,
`has_cookie_manager` BOOLEAN,
`has_campout_certified` BOOLEAN,
`has_share_leader` BOOLEAN,
`volunteers` TEXT,
`number_volunteers` VARCHAR(20),
`first_aider` TEXT,
`first_aider_email` TEXT,
`money_manager` TEXT,
`money_manager_email` TEXT,
`fall_product` TEXT,
`fall_product_email` TEXT,
`cookie_manager` TEXT,
`cookie_manager_email` TEXT,
`campout_certified` TEXT,
`campout_certified_email` TEXT,
`share_leader` TEXT,
`share_leader_email` TEXT,
`roster_email` TEXT,
UNIQUE KEY idx_troop_id (id)
)
CHARACTER SET utf8;

insert into troops (id) select distinct troop_id from roster;

/* get the levels */
insert into troops (id, level)
(
  select troop_id, group_concat(distinct(level)) fROM girlscouts.roster r where level != "" and troop_id not like "Service%" group by troop_id
) on duplicate key update level=values(level);


insert into troops (id, leaders, leader_emails, number_leaders)
(
  select troop_id, group_concat(distinct(name) SEPARATOR ', '), group_concat(distinct(email) SEPARATOR ', '), count(distinct(name)) from (
  select troop_id, concat(first, " ", last) as name, email FROM roster r where role="Troop Leader" order by email
  ) as tmp group by troop_id
) on duplicate key update leaders=values(leaders), leader_emails=values(leader_emails), number_leaders=values(number_leaders);


insert into troops (id, girls, number_girls)
(
  select troop_id, group_concat(name SEPARATOR ', '), count(name) from (
  select troop_id, concat(first, " ", left(last, 1), ".") as name, email FROM roster r where role="Girl Scout" order by email
  ) as tmp group by troop_id
) on duplicate key update girls=values(girls), number_girls=values(number_girls);


insert into troops (id, volunteers, number_volunteers)
(
  select troop_id, group_concat(distinct(name) SEPARATOR ', '), count(distinct(name)) from (
  select troop_id, concat(first, " ", last) as name, email FROM roster r where role in ("Friends and Family Volunteer", "Adult Members") order by email
  ) as tmp group by troop_id
) on duplicate key update volunteers=values(volunteers), number_volunteers=values(number_volunteers);


/** First Aider **/
insert into troops (id, first_aider, first_aider_email)
(
  select troop_id, group_concat(distinct(name) SEPARATOR ', ') as name, group_concat(distinct(email) SEPARATOR ', ') as email from (
  select troop_id, concat(first, " ", last) as name, email FROM roster r where role in ("First Aider") order by email
  ) as tmp group by troop_id
) on duplicate key update first_aider=values(first_aider), first_aider_email=values(first_aider_email);
update troops set has_first_aider=if(first_aider is not null, 1 , 0);

/** Money Manager **/
insert into troops (id, money_manager, money_manager_email)
(
  select troop_id, group_concat(distinct(name) SEPARATOR ', ') as name, group_concat(distinct(email) SEPARATOR ', ') as email from (
  select troop_id, concat(first, " ", last) as name, email FROM roster r where role in ("Troop Money Manager") order by email
  ) as tmp group by troop_id
) on duplicate key update money_manager=values(money_manager), money_manager_email=values(money_manager_email);
update troops set has_money_manager=if(money_manager is not null, 1 , 0);


/** Fall Product **/
insert into troops (id, fall_product, fall_product_email)
(
  select troop_id, group_concat(distinct(name) SEPARATOR ', ') as name, group_concat(distinct(email) SEPARATOR ', ') as email from (
  select troop_id, concat(first, " ", last) as name, email FROM roster r where role in ("Troop Fall Product Manager") order by email
  ) as tmp group by troop_id
) on duplicate key update fall_product=values(fall_product), fall_product_email=values(fall_product_email);
update troops set has_fall_product=if(fall_product is not null, 1 , 0);


/** Cookie **/
insert into troops (id, cookie_manager, cookie_manager_email)
(
  select troop_id, group_concat(distinct(name) SEPARATOR ', ') as name, group_concat(distinct(email) SEPARATOR ', ') as email from (
  select troop_id, concat(first, " ", last) as name, email FROM roster r where role in ("Troop Cookie Manager") order by email
  ) as tmp group by troop_id
) on duplicate key update cookie_manager=values(cookie_manager), cookie_manager_email=values(cookie_manager_email);
update troops set has_cookie_manager=if(cookie_manager is not null, 1 , 0);

/** Campout **/
insert into troops (id, campout_certified, campout_certified_email)
(
  select troop_id, group_concat(distinct(name) SEPARATOR ', ') as name, group_concat(distinct(email) SEPARATOR ', ') as email from (
  select troop_id, concat(first, " ", last) as name, email FROM roster r where role in ("Campout/Cookout Certified Adult") order by email
  ) as tmp group by troop_id
) on duplicate key update campout_certified=values(campout_certified), campout_certified_email=values(campout_certified_email);
update troops set has_campout_certified=if(campout_certified is not null, 1 , 0);


/** SHARE **/
insert into troops (id, share_leader, share_leader_email)
(
  select troop_id, group_concat(distinct(name) SEPARATOR ', ') as name, group_concat(distinct(email) SEPARATOR ', ') as email from (
  select troop_id, concat(first, " ", last) as name, email FROM roster r where role in ("Troop SHARE Chair") order by email
  ) as tmp group by troop_id
) on duplicate key update share_leader=values(share_leader), share_leader_email=values(share_leader_email);
update troops set has_share_leader=if(share_leader is not null, 1 , 0);

/** early birded girls **/
insert into troops (id, girls_early_birded) (
  SELECT troop_id, count(first) as girls_early_birded FROM girlscouts.roster r where membership_type="Youth" and membership_status="Active" group by troop_id
) on duplicate key update girls_early_birded=values(girls_early_birded);


/** roster email **/
insert into troops (id, roster_email)
(
  select troop_id, group_concat(distinct(foo) order by foo SEPARATOR '+') from (
  select troop_id, trim(concat(first, " ", last, " - Grade ", trim(grade), " at ", school)) as foo FROM roster r where role="Girl Scout" 
  ) as tmp group by troop_id
) on duplicate key update roster_email=values(roster_email);



/** OVERVIEW **/
drop table if exists dashboard;
create table dashboard (
  `level` VARCHAR(255),
  `number_troops` VARCHAR(20) DEFAULT "-",
  `number_girls` VARCHAR(20)  DEFAULT "-",
  `number_leaders` VARCHAR(20) DEFAULT "-",
  UNIQUE KEY idx_dashboard_level (level)
) CHARACTER SET utf8;


insert into dashboard (level, number_troops, number_leaders) (
   select COALESCE(level, "Not Specified"), count(distinct(id)), COALESCE(sum(number_leaders), 0) from troops group by level
) on duplicate key update number_troops=values(number_troops), number_leaders=values(number_leaders);


insert into dashboard (level, number_girls) (
   select "1-Daisy",  count(email) as number_girls from roster where role="Girl Scout" and (grade like "%K%" or grade=1)
) on duplicate key update number_girls=values(number_girls);

insert into dashboard (level, number_girls) (
   select "2-Brownie",  count(email) as number_girls from roster where role="Girl Scout" and grade in (2, 3)
) on duplicate key update number_girls=values(number_girls);

insert into dashboard (level, number_girls) (
   select "3-Junior",  count(email) as number_girls from roster where role="Girl Scout" and grade in (4, 5)
) on duplicate key update number_girls=values(number_girls);

insert into dashboard (level, number_girls) (
   select "4-Cadette",  count(email) as number_girls from roster where role="Girl Scout" and grade in (6, 7, 8)
) on duplicate key update number_girls=values(number_girls);

insert into dashboard (level, number_girls) (
   select "5-Senior",  count(email) as number_girls from roster where role="Girl Scout" and grade in (9, 10)
) on duplicate key update number_girls=values(number_girls);

insert into dashboard (level, number_girls) (
   select "6-Ambassador",  count(email) as number_girls from roster where role="Girl Scout" and grade in (11, 12)
) on duplicate key update number_girls=values(number_girls);


insert into dashboard (
   select "Total" as level, count(distinct(id)), sum(number_girls), sum(number_leaders) from troops 
) on duplicate key update number_troops=values(number_troops), number_leaders=values(number_leaders), number_girls=values(number_girls);


insert into dashboard (
   select "2025 Early Bird - Girl" as level, count(distinct(troop_id)), count(distinct(concat(first, last, email))), 0 from roster  where membership_type="Youth" and  membership_status="Active" 
) on duplicate key update number_troops=values(number_troops), number_leaders=values(number_leaders), number_girls=values(number_girls);


insert into dashboard (
   select "2025 Early Bird - Adult" as level, count(distinct(troop_id)), 0, count(distinct(concat(first, last, email))) from roster  where membership_type="Adult" and  membership_status="Active" 
) on duplicate key update number_troops=values(number_troops), number_leaders=values(number_leaders), number_girls=values(number_girls);


/** Sanity check **/
SELECT sum(number_girls) FROM girlscouts.dashboard d where level!="Total" and level not like "%Early Bird%";
SELECT sum(number_girls) FROM girlscouts.dashboard d where level="Total";


drop table if exists contacts;
create table contacts (
`position` VARCHAR(255),
`names` TEXT,
`emails` TEXT,
`number_volunteers` VARCHAR(20),
`number_troops` VARCHAR(20)
)
CHARACTER SET utf8;


insert into contacts  (
  select role,  group_concat(name SEPARATOR ', '), group_concat(email SEPARATOR ', '), count(distinct(name)), count(distinct(troop_id)) from (
    select role, concat(first, " ", last) as name, email, troop_id from roster  where role not in ("Adult Members", "Girl Scout", "Friends and Family Volunteer")
  ) as temp where role not like "Service%" group by role
);
/** Sort SU last **/
insert into contacts  (
  select role,  group_concat(name SEPARATOR ', '), group_concat(email SEPARATOR ', '), count(distinct(name)), count(distinct(troop_id)) from (
    select role, concat(first, " ", last) as name, email, troop_id from roster  where role not in ("Adult Members", "Girl Scout", "Friends and Family Volunteer")
  ) as temp where role like "Service%" group by role
);



drop table if exists leader_roster;
create table leader_roster (
`id` VARCHAR(255) NOT NULL,
`level` VARCHAR(255),
`leaders` TEXT,
`leader_emails` TEXT,
`number_leaders` VARCHAR(20),
`number_girls` VARCHAR(20),
UNIQUE KEY idx_troop_id (id)
)
CHARACTER SET utf8;

insert into leader_roster (id) select distinct troop_id from roster;

/* get the levels */
insert into leader_roster (id, level)
(
  select troop_id, group_concat(distinct(level)) fROM girlscouts.roster r where level != "" and troop_id not like "Service%" group by troop_id
) on duplicate key update level=values(level);


insert into leader_roster (id, leaders, leader_emails, number_leaders)
(
  select troop_id, group_concat(distinct(name) SEPARATOR ', '), group_concat(distinct(email) SEPARATOR ', '), count(distinct(name)) from (
  select troop_id, concat(first, " ", last) as name, email FROM roster r where role="Troop Leader" order by email
  ) as tmp group by troop_id
) on duplicate key update leaders=values(leaders), leader_emails=values(leader_emails), number_leaders=values(number_leaders);


insert into leader_roster (id, number_girls)
(
  select troop_id, count(distinct(name)) from (
  select troop_id, concat(first, " ", left(last, 1), ".") as name, email FROM roster r where role="Girl Scout" order by email
  ) as tmp group by troop_id
) on duplicate key update number_girls=values(number_girls);



drop table if exists troop_roster;
create table troop_roster (
`id` VARCHAR(255) NOT NULL,
`level` VARCHAR(255),
`leaders` TEXT,
`girls` TEXT,
`number_girls` VARCHAR(20),
UNIQUE KEY idx_troop_roster_id (id)
)
CHARACTER SET utf8;

insert into troop_roster (id, level)
(
  select troop_id, group_concat(distinct(level)) fROM girlscouts.roster r where level != "" and troop_id not like "Service%" group by troop_id
) on duplicate key update level=values(level);

insert into troop_roster (id, leaders)
(
  select troop_id, group_concat(distinct(name) SEPARATOR ', ') from (
  select troop_id, concat(first, " ", last) as name, email FROM roster r where role="Troop Leader" order by email
  ) as tmp group by troop_id
) on duplicate key update leaders=values(leaders);


insert into troop_roster (id, girls, number_girls)
(
  select troop_id, group_concat(distinct(name) order by name SEPARATOR '+'), count(distinct(name)) from (
  select troop_id, concat(first, " ", last) as name FROM roster r where role="Girl Scout" 
  ) as tmp group by troop_id
) on duplicate key update girls=values(girls), number_girls=values(number_girls);


/** LONGEVITY REPORT **/ 
drop table if exists longevity_report;
create table longevity_report (
`first` VARCHAR(255),
`last` VARCHAR(255),
`email` VARCHAR(255),
`roles` TEXT,
`earliest_role_date` DATE,
UNIQUE KEY idx_longevity_report_email (email)
)
CHARACTER SET utf8;


insert into longevity_report (first, last, email, roles, earliest_role_date)
(
select min(rr.`first`) as `first` , min(rr.`last`) as `last`,  rr.email,  GROUP_CONCAT(rr.role) as `roles`, min(rr.longevity_date) as earliest_role_date from 
(select r.`first`, r.`last`, r.email, r.`role`, STR_TO_DATE(r.start_date, '%m/%d/%y') as longevity_date from roster r  where membership_type="Adult" ) as rr
group by rr.email
) on duplicate key update earliest_role_date=values(earliest_role_date);

