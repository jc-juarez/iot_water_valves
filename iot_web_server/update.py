# Tecnológico de Monterrey
# Computerized Control
# Final Project
# IoT Water Valves

import sqlite3
import os
import requests

def update_water_limit(limit):

    current_dir = os.path.dirname(os.path.abspath(__file__))

    connection = sqlite3.connect(current_dir + "/system.db")

    cursor = connection.cursor()

    data_query = "UPDATE system_limit SET water_limit = {0} WHERE main_id = 'main'".format(limit)

    cursor.execute(data_query)

    connection.commit()

def start_system():
    requests.get('http://localhost:2000/api/start-system')

def stop_system():
    requests.get('http://localhost:2000/api/stop-system')

def set_current_water_limit(liters):
    liters = str(liters)
    requests.get('http://localhost:2000/api/set-current-liters/{0}'.format(liters))
