drop database girlscouts;

create database girlscouts;
use girlscouts;
drop table if exists roster;

create table roster (
  `su` VARCHAR(255),
  `troop_id` VARCHAR(255),
  `level` VARCHAR(255),
  `start_date` VARCHAR(255),
  `end_date` VARCHAR(255),
  `role` VARCHAR(255),  
  `background_check_status` VARCHAR(255),
  `first` VARCHAR(255),
  `last` VARCHAR(255),
  `membership_type` VARCHAR(255),
  `email` TEXT,
  `phone` VARCHAR(255),
  `phone_type` VARCHAR(255),
  `secondary_phone` VARCHAR(255),
  `secondary_phone_type` VARCHAR(255),
  `primary_caregiver_first` VARCHAR(255),
  `primary_caregiver_last` VARCHAR(255),
  `primary_caregiver_phone` VARCHAR(255),
  `primary_caregiver_email` VARCHAR(255),
  `address` TEXT,
  `city` VARCHAR(255),
  `state` VARCHAR(255),
  `zip` VARCHAR(255),
  `membership_status` VARCHAR(255),
  `renewal_date` VARCHAR(255),
  `school` TEXT,
  `grade` TEXT
) CHARACTER SET utf8;

