# THIS SCRIPT IS MEANT TO BE RUN ONCE EVERY DAY, TO CLEAR OLD DATA NO LONGER NEEDED
from sql_helpers import connect_to_mysql
conn = connect_to_mysql()
cursor = conn.cursor()
# If you are having issues deleting old data, try disabling SAFE mode.
cursor.execute("DELETE FROM SENSOR_READINGS WHERE TIMESTAMPDIFF(DAY, SENSOR_READINGS.TIMESTP, NOW()) > 14;")
conn.close()
