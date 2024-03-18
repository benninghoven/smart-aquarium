from sensor_generator import SensorGenerator
from get_db_and_cursor import get_db_and_cursor
from datetime import datetime, timedelta

db, cur = get_db_and_cursor()
generator = SensorGenerator()

# can also set to a day
sim_dt = datetime.now() - timedelta(days=10)


# 14400 minutes from 10 days ago until now, will run until about 6 hours before current date
for _ in range(14000):
    rand_data = generator.generate_values()
    sim_dt += timedelta(minutes=1)
    cur.execute(f"INSERT INTO SENSOR_READINGS (username, timestp, water_temp, PPM, pH) VALUES ('TESTUSER', '{sim_dt.strftime('%Y/%m/%d %H:%M:%S')}', {rand_data['temperature']}, {rand_data['ppm']}, {rand_data['ph']});")
    #do not need to commit every time but need to do often enough to avoid overflowing the buffer. May lower number if have weird errors
    if _ % 1000 == 0:
        print(_/14000 * 100, "% done")
        db.commit()

db.commit()
cur.close()
