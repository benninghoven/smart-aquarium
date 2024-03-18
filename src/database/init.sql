DROP DATABASE IF EXISTS FISHOLOGY;
CREATE DATABASE FISHOLOGY;

USE FISHOLOGY;


#hashed password, hash_val length will be fixed
#may need to add val for API key or API key generator
CREATE TABLE IF NOT EXISTS accounts(
username		VARCHAR(20) NOT NULL,
hashed_pw		CHAR(255),
salt_val		CHAR(16),
PRIMARY KEY(username)
);


# Need to check if the sensor data is in float form
# test the NOW() function, may need to create a trigger
CREATE TABLE IF NOT EXISTS SENSOR_READINGS(
username		VARCHAR(20) NOT NULL,
timestp 		DATETIME NOT NULL DEFAULT NOW(),
water_temp		FLOAT,
PPM				SMALLINT,
pH				FLOAT,
PRIMARY KEY(username, timestp)
);



CREATE TABLE IF NOT EXISTS FISH_TOLERANCES(
fish_name		VARCHAR(50),
max_temp		float,
min_temp		float,
max_ppm			float,
min_ppm			float,
max_ph			float,
min_ph			float,
PRIMARY KEY(fish_name)
);
