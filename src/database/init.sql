DROP DATABASE IF EXISTS FISHOLOGY;
CREATE DATABASE FISHOLOGY;

USE FISHOLOGY;


CREATE TABLE IF NOT EXISTS accounts(
username		VARCHAR(20) NOT NULL,
hashed_pw		CHAR(60),
salt_val		CHAR(29),
tank_id			INT NOT NULL,
PRIMARY KEY(username, tank_id)
);


CREATE TABLE IF NOT EXISTS SENSOR_READINGS(
username		VARCHAR(20) NOT NULL,
timestp 		DATETIME NOT NULL DEFAULT NOW(),
water_temp		FLOAT,
PPM				SMALLINT,
pH				FLOAT,
PRIMARY KEY (username, timestp),
FOREIGN KEY (username) REFERENCES accounts(username)
);


CREATE TABLE IF NOT EXISTS FISH_TOLERANCES(
fish_name		VARCHAR(50) NOT NULL,
max_temp		float,
min_temp		float,
max_ppm			float,
min_ppm			float,
max_ph			float,
min_ph			float,
PRIMARY KEY(fish_name)
);


CREATE TABLE IF NOT EXISTS FISH_IN_USER_TANK(
username		VARCHAR(20) NOT NULL,
tank_id			INT NOT NULL,
fish			VARCHAR(50),
FOREIGN KEY (username, tank_id) REFERENCES accounts(username, tank_id)
);


# add a starter account
INSERT INTO accounts VALUES ('TESTUSER', 'XXXXXXXXXXXXXXXXXXXXX', 'XXXXXXXXXXXX', 1111111111);