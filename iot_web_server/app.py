# Tecnológico de Monterrey
# Computerized Control
# Final Project
# IoT Water Valves

import streamlit as st
import time
from datetime import datetime, timedelta
from fetch import *
from update import *

st.title("Computerized Control - Water Control System")

# Total Number of People currently Inside

current_water_limit = get_water_limit()

st.metric("Current Water Limit in Liters: ", current_water_limit, delta=None, delta_color="normal")

# Change Max Capacity Input

number = st.number_input('Insert a number to change Water Limit per day (Liters): ')

if st.button('Change Water Limit') and number >= 0:
    update_water_limit(number)
    st.write('Water Limit has been changed succesfully.')
    time.sleep(3)
else:
    pass

# ------------------------------
# Re-Run App every half a second
# ------------------------------

time.sleep(0.5)

st.experimental_rerun()