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
    

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=2000, debug=True)