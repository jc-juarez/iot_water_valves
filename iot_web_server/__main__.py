from flask import Flask
import sqlite3
import os

current_dir = os.path.dirname(os.path.abspath(__file__))

app = Flask(__name__)

# Main Route
@app.route("/api/")
def entry():
    return "Server is running."

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=2000, debug=True)