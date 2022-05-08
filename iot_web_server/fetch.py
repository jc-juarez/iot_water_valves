# Tecnológico de Monterrey
# Computerized Control
# Final Project
# IoT Water Valves

import requests

def get_water_limit():
    r =requests.get('http://localhost:2000/api/check-water-limit')
    return r.text