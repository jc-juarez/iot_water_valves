# Tecnológico de Monterrey
# Computerized Control
# Final Project
# IoT Water Valves

import streamlit as st
import time
from datetime import datetime, timedelta
from fetch import *
from update import *

st.title("Computerized Control - Iot Water Valves System")

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

# Extra Space
for i in range(4):
    st.text("")

# Check if system is running
system_running = int(get_system_state())

if(not system_running):
    if st.button('Start System'):
        set_current_water_limit(float(current_water_limit))
        print("a " + str(float(current_water_limit)))
        start_system()
        has_started_once = True
    else:
        st.success("The System Has Finished or has not been started yet. Press 'Start System' to begin.")   
else:
    if st.button('Stop System'):
        stop_system()
    else:
        remaining_liters = get_liters()
        remaining_ratio = float((float(remaining_liters) * 100.0) / float(get_current_water_limit()))
        print(get_current_water_limit())
        st.text("Remaining Liters for use: {0} Liters".format(remaining_liters))
        my_bar = st.progress(int(remaining_ratio))

# ------------------------------
# Re-Run App every half a second
# ------------------------------

time.sleep(0.5)

st.experimental_rerun()