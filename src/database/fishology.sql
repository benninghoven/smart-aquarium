DROP DATABASE IF EXISTS FISHOLOGY;
CREATE DATABASE FISHOLOGY;

USE FISHOLOGY;


#hashed password, hash_val length will be fixed
#may need to add val for API key or API key generator
DROP TABLE accounts;
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


INSERT INTO SENSOR_READINGS (username, timestp, water_temp, PPM, pH) VALUES
("TESTUSER", '2024-02-24 11:46:21', 74.3, 50, 6.73);

# ALL READINGS
SELECT * FROM SENSOR_READINGS;

# READINGS FROM WITHIN THE LAST 24HR
SELECT * FROM SENSOR_READINGS
WHERE TIMESTAMPDIFF(DAY, SENSOR_READINGS.TIMESTP, NOW()) < 1;

# GET READINGS FOR SPECIFIC USER LAST 24HR
SET @USER = "TESTUSER";
SELECT * FROM SENSOR_READINGS
WHERE TIMESTAMPDIFF(DAY, SENSOR_READINGS.TIMESTP, NOW()) < 1 AND username = @USER;

# STORED PROCEDURE -- NOT WORKING
DELIMITER $$
CREATE PROCEDURE LAST_24HR_DATA(
IN USERNAME VARCHAR(20)
)

