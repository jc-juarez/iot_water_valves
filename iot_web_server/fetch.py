# Tecnológico de Monterrey
# Computerized Control
# Final Project
# IoT Water Valves

import requests

def get_water_limit():
    r = requests.get('http://localhost:2000/api/check-water-limit')
    return r.text

def get_system_state():
    r = requests.get('http://localhost:2000/api/check-system-running')
    return r.text

def get_liters():
    r = requests.get('http://localhost:2000/api/get-remaining-liters')
    return r.text

def get_current_water_limit():
    r = requests.get('http://localhost:2000/api/get-current-liters')
    return r.text