drop database girlscouts;
create database girlscouts;

use girlscouts;

drop table if exists roster;
create table roster (
`su` VARCHAR(255),
`troop_id` VARCHAR(255),
`level` VARCHAR(255),
`role` VARCHAR(255),
`background_check_expires` VARCHAR(255),
`first` VARCHAR(255),
`last` VARCHAR(255),
`email` TEXT,
`phone` VARCHAR(255),
`membership_type` VARCHAR(255),
`membership_year` VARCHAR(255),
`grade` VARCHAR(255),
`school` VARCHAR(255)
) CHARACTER SET utf8;
