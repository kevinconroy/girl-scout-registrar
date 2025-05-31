drop table if exists roster;
create table roster (
`id` VARCHAR(255) NOT NULL,
`level` VARCHAR(255),
`leader_emails` TEXT,
`leaders` TEXT,
`girls` TEXT,
`first_aider` TEXT,
`money_manager` TEXT,
`fall_product` TEXT,
`cookie_manager` TEXT,
`campout_certified` TEXT,
`share_leader` TEXT,
UNIQUE KEY idx_troop_id (id)
)
CHARACTER SET utf8;

insert into roster (id) select distinct troop_id from roster;

/* get the levels */
insert into roster (id, level)
(
  select troop_id, group_concat(distinct(level)) fROM girlscouts.roster r where level != "" and troop_id not like "Service%" group by troop_id
) on duplicate key update level=values(level);


insert into roster (id, leaders, leader_emails, number_leaders)
(
  select troop_id, group_concat(distinct(name) SEPARATOR ', '), group_concat(distinct(email) SEPARATOR ', '), count(distinct(name)) from (
  select troop_id, concat(first, " ", last) as name, email FROM roster r where role="Troop Leader" order by email
  ) as tmp group by troop_id
) on duplicate key update leaders=values(leaders), leader_emails=values(leader_emails), number_leaders=values(number_leaders);


insert into roster (id, girls, number_girls)
(
  select troop_id, group_concat(name SEPARATOR ', '), count(name) from (
  select troop_id, concat(first, " ", last) as name, email FROM roster r where role="Girl Scout" order by email
  ) as tmp group by troop_id
) on duplicate key update girls=values(girls), number_girls=values(number_girls);


/** First Aider **/
insert into roster (id, first_aider)
(
  select troop_id, group_concat(distinct(name) SEPARATOR ', ') as name from (
  select troop_id, concat(first, " ", last) as name FROM roster r where role in ("First Aider") order by email
  ) as tmp group by troop_id
) on duplicate key update first_aider=values(first_aider);


/** Money Manager **/
insert into roster (id, money_manager, money_manager_email)
(
  select troop_id, group_concat(distinct(name) SEPARATOR ', ') as name, group_concat(distinct(email) SEPARATOR ', ') as email from (
  select troop_id, concat(first, " ", last) as name, email FROM roster r where role in ("Troop Money Manager") order by email
  ) as tmp group by troop_id
) on duplicate key update money_manager=values(money_manager), money_manager_email=values(money_manager_email);
update roster set has_money_manager=if(money_manager is not null, 1 , 0);


/** Fall Product **/
insert into roster (id, fall_product, fall_product_email)
(
  select troop_id, group_concat(distinct(name) SEPARATOR ', ') as name, group_concat(distinct(email) SEPARATOR ', ') as email from (
  select troop_id, concat(first, " ", last) as name, email FROM roster r where role in ("Troop Fall Product Manager") order by email
  ) as tmp group by troop_id
) on duplicate key update fall_product=values(fall_product), fall_product_email=values(fall_product_email);
update roster set has_fall_product=if(fall_product is not null, 1 , 0);


/** Cookie **/
insert into roster (id, cookie_manager, cookie_manager_email)
(
  select troop_id, group_concat(distinct(name) SEPARATOR ', ') as name, group_concat(distinct(email) SEPARATOR ', ') as email from (
  select troop_id, concat(first, " ", last) as name, email FROM roster r where role in ("Troop Cookie Manager") order by email
  ) as tmp group by troop_id
) on duplicate key update cookie_manager=values(cookie_manager), cookie_manager_email=values(cookie_manager_email);
update roster set has_cookie_manager=if(cookie_manager is not null, 1 , 0);

/** Campout **/
insert into roster (id, campout_certified, campout_certified_email)
(
  select troop_id, group_concat(distinct(name) SEPARATOR ', ') as name, group_concat(distinct(email) SEPARATOR ', ') as email from (
  select troop_id, concat(first, " ", last) as name, email FROM roster r where role in ("Campout/Cookout Certified Adult") order by email
  ) as tmp group by troop_id
) on duplicate key update campout_certified=values(campout_certified), campout_certified_email=values(campout_certified_email);
update roster set has_campout_certified=if(campout_certified is not null, 1 , 0);


/** SHARE **/
insert into roster (id, share_leader, share_leader_email)
(
  select troop_id, group_concat(distinct(name) SEPARATOR ', ') as name, group_concat(distinct(email) SEPARATOR ', ') as email from (
  select troop_id, concat(first, " ", last) as name, email FROM roster r where role in ("Troop SHARE Leader") order by email
  ) as tmp group by troop_id
) on duplicate key update share_leader=values(share_leader), share_leader_email=values(share_leader_email);
update roster set has_share_leader=if(share_leader is not null, 1 , 0);



