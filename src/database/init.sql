DROP DATABASE IF EXISTS FISHOLOGY;
CREATE DATABASE FISHOLOGY;

USE FISHOLOGY;


CREATE TABLE IF NOT EXISTS accounts(
username		VARCHAR(20) NOT NULL,
hashed_pw		CHAR(60),
salt_val		CHAR(29),
tank_id			INT NOT NULL,
PRIMARY KEY(tank_id, username)
);


CREATE TABLE IF NOT EXISTS SENSOR_READINGS(
tank_id			INT NOT NULL,
timestp 		DATETIME NOT NULL DEFAULT NOW(),
water_temp		FLOAT,
PPM				SMALLINT,
pH				FLOAT,
PRIMARY KEY (tank_id, timestp),
FOREIGN KEY (tank_id) REFERENCES accounts(tank_id)
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
tank_id			INT NOT NULL,
fish			VARCHAR(50),
FOREIGN KEY (tank_id) REFERENCES accounts(tank_id),
FOREIGN KEY (fish) REFERENCES FISH_TOLERANCES(fish_name)
);


CREATE TABLE IF NOT EXISTS ALERTS(
tank_id			INT NOT NULL,
alert			VARCHAR(240),
FOREIGN KEY (tank_id) REFERENCES accounts(tank_id)
);


# add a starter account
INSERT INTO accounts VALUES ('TESTUSER', 'XXXXXXXXXXXXXXXXXXXXX', 'XXXXXXXXXXXX', 1111111111);