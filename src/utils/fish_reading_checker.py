from utils.sql_helpers import connect_to_mysql, execute_query, query_to_json
from datetime import datetime

class fish_checker:
    def __init__(self, conn, tank_id = 1111111111, debug = False):
        self.tank_id = tank_id
        conn = connect_to_mysql()
        cursor = conn.cursor()
        query = f"""SELECT tank_id, fish_name, max_temp, min_temp, max_ppm, min_ppm, max_ph, min_ph from FISH_IN_USER_TANK INNER JOIN FISH_TOLERANCES ON fish = fish_name WHERE tank_id = {tank_id};"""
        print(query)
        cursor.execute(query)
        self.fish_in_tank = cursor.fetchall()
        if debug:
            print("read in: ", self.fish_in_tank)

    # help for resolving loops
    def __len__(self):
        return len(self.fish_in_tank)
    
    
    
    def check_bounds(self, temp, ppm, ph, time, add_alert, debug = False):
        # using if statements instead of elif because user will want to know everything that is wrong, not just first thing
        problems = []
        for fish in self.fish_in_tank:
            if fish[2] < temp:
                problems.append(get_error_msg(time, "temp", "above", fish[1], temp, fish[3], fish[2], pr=debug))
            if fish[3] > temp:
                problems.append(get_error_msg(time, "temp", "below", fish[1], temp, fish[3], fish[2], pr=debug))
            if fish[4] < ppm:
                problems.append(get_error_msg(time, "ppm", "above", fish[1], ppm, fish[5], fish[4], pr=debug))
            if fish[5] > ppm:
                problems.append(get_error_msg(time, "ppm", "below", fish[1], ppm, fish[5], fish[4], pr=debug))
            if fish[6] < ph:
                problems.append(get_error_msg(time, "ph", "above", fish[1], ph, fish[7], fish[6], pr=debug))
            if fish[7] > ph:
                problems.append(get_error_msg(time, "ph", "below", fish[1], ph, fish[7], fish[6], pr=debug))
        
        # add alert(s) to db
        if add_alert and problems:
            conn = connect_to_mysql()
            cursor = conn.cursor()
            query = "INSERT INTO ALERTS VALUES "
            for i in problems:
                query += '(' + str(self.tank_id) + ', "' + i + '"),'
            # remove last comma
            cursor.execute(query[:-1])
            cursor.close()
            conn.commit()
            conn.close()
        return problems

# debug and visualize problem 
def get_error_msg(time, type, bound, fish, val, exp_l, exp_h, pr=False):
    msg = time.strftime('%Y/%m/%d %H:%M:%S') + " Reading " + str(val) + " is " + bound + " acceptable range for " + type + " for " + fish + ": " + str(exp_l)  + "-" + str(exp_h)
    if pr:
        print(msg)
    return msg