# Tecnológico de Monterrey
# Computerized Control
# Final Project
# IoT Water Valves

from flask import Flask
import sqlite3
import os

current_dir = os.path.dirname(os.path.abspath(__file__))

app = Flask(__name__)

# Main Route
@app.route("/")
def entry():
    return "Server is running..."

# Water Limit
@app.route("/api/check-water-limit")
def check_water_limit():

    connection = sqlite3.connect(current_dir + "/system.db")

    cursor = connection.cursor()

    data_query = "SELECT * FROM system_limit"

    cursor.execute(data_query)

    data = cursor.fetchall()

    current_water_limit = 0

    # Get the Max Capacity which is the second argument
    current_water_limit = float(data[0][1])

    current_water_limit = round(current_water_limit, 2)

    current_water_limit = str(current_water_limit)

    connection.commit()

    return current_water_limit

# Check if system is running
@app.route("/api/check-system-running")
def check_system_running():

    connection = sqlite3.connect(current_dir + "/system.db")

    cursor = connection.cursor()

    data_query = "SELECT * FROM system_running"

    cursor.execute(data_query)

    data = cursor.fetchall()

    running = 0

    # Get the variable to check if the system is currently running to start execution at Matlab Server
    running = int(data[0][1])

    running = str(running)

    connection.commit()

    return running

# Get remaining liters
@app.route("/api/get-remaining-liters")
def get_remaining_liters():

    connection = sqlite3.connect(current_dir + "/system.db")

    cursor = connection.cursor()

    data_query = "SELECT * FROM system_liters"

    cursor.execute(data_query)

    data = cursor.fetchall()

    liters = 0

    # Get the variable to check if the system is currently running to start execution at Matlab Server
    liters = float(data[0][1])

    liters = str(liters)

    connection.commit()

    return liters

# Set current liters
@app.route("/api/set-remaining-liters/<liters>")
def set_remaining_liters(liters):

    connection = sqlite3.connect(current_dir + "/system.db")

    cursor = connection.cursor()

    liters = float(liters)

    liters = str(liters)

    data_query = "UPDATE system_liters SET liters = {0} WHERE main_id = 'main'".format(liters)

    cursor.execute(data_query)

    connection.commit()

    return "Liters have been updated"

# Start system
@app.route("/api/start-system")
def start_system():

    connection = sqlite3.connect(current_dir + "/system.db")

    cursor = connection.cursor()

    data_query = "UPDATE system_running SET running = 1 WHERE main_id = 'main'"

    cursor.execute(data_query)

    connection.commit()

    return "System has started"

# Stop system
@app.route("/api/stop-system")
def stop_system():

    connection = sqlite3.connect(current_dir + "/system.db")

    cursor = connection.cursor()

    data_query = "UPDATE system_running SET running = 0 WHERE main_id = 'main'"

    cursor.execute(data_query)

    connection.commit()

    return "System has stopped"

# Get current transaction water limit
@app.route("/api/get-current-liters")
def get_current_liters():

    connection = sqlite3.connect(current_dir + "/system.db")

    cursor = connection.cursor()

    data_query = "SELECT * FROM system_current"

    cursor.execute(data_query)

    data = cursor.fetchall()

    liters = 0

    # Get the variable to check if the system is currently running to start execution at Matlab Server
    liters = float(data[0][1])

    liters = str(liters)

    connection.commit()

    return liters

# Set current liters
@app.route("/api/set-current-liters/<liters>")
def set_current_liters(liters):

    connection = sqlite3.connect(current_dir + "/system.db")

    cursor = connection.cursor()

    liters = float(liters)

    liters = str(liters)

    data_query = "UPDATE system_current SET liters = {0} WHERE main_id = 'main'".format(liters)

    cursor.execute(data_query)

    connection.commit()

    return "Current Liters have been updated"
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=2000, debug=True)