% Tecnológico de Monterrey
% Computerized Control Final Project
% IoT Water Valves
% Matlab Server

% ----- Main Configuration ---------------------------------

clear all;
clc;

% Create connection to Arduino Uno
arduino_uno = arduino('COM6','Uno','libraries','Ultrasonic');
%% 

% Create Sensor Instance
ultrasonic_sensor = ultrasonic(arduino_uno,'D2','D3');

% Variable for While True
true_variable = 10;

% Initial Water Limit (In Liters)
water_limit = 0.5;

% Predefined values
clc;
T = 0.1;
n = 1000000; % Predefined Value for Plot in X-axis

% -------------------------------------------------

% API URL for alerting user that system has finished

api_url_finished = "http://localhost:2000/api/stop-system";

while true_variable > 1

    % Check Water Limit Before Daily Execution -----------------------

    api_url = "http://localhost:2000/api/check-water-limit";
%% 

    api_call = webread(api_url);
%% 

    new_limit = str2double(api_call);

    if ~eq(water_limit, new_limit)

        fprintf('Water Limit has been changed from %f to %f.\n', water_limit,new_limit);
        water_limit = new_limit;
        pause(3);

    end

    % Check system state for execution start -----------------------------

    check_system_running = "http://localhost:2000/api/check-system-running";
    response_running = webread(check_system_running);
    if(response_running == "1")
        
        % Initial Variables Configuration ----------------------------------------

        % Set Current Limit

        base_api_url_liters = "http://localhost:2000/api/set-remaining-liters/";
        
        url_liters = num2str(water_limit);
        
        full_api_url_liters = append(base_api_url_liters, url_liters);
    
        response_liters = webread(full_api_url_liters);

        % Initial Water Flow of 5 Liters per Minute

        setpoint = 5;

        r = zeros(n,1) + setpoint; % Starts at 5 Liters per minute

        % Tuning Values

        kp = 10;
        ki = 0.07;

        % Initial Values for non Zero Indexing (Only c(k) and e(k))
        % Clean arrays

        % Using a PLant Process specifically for a Water Flow System

        c = [];
        e = [];
        m = [];

        c(1) = 0;
        e(1) = r(1) - c(1); % r(1) is r(1)
        m(1) = 1/2 * ((2 * kp + ki * T) * e(1));
        
        c(2) = 0.0392 * m(1) + 0.9842 * c(1);
        e(2) = r(1) - c(2); % r(1) is r(2)
        m(2) = 1/2 * ((2 * kp + ki * T) * e(2) + (ki * T - 2 * kp) * e(1)) + m(1);

        k = 3;
        t = 1:n;
        x = 1:n;
        
        while true_variable > 1

            % Check if user has stopped the system
            response_running_stopped = webread(check_system_running);
            if(response_running_stopped == "0")
                break
            end

            % Distance in cm
            distance = readDistance(ultrasonic_sensor) * 100;
        
            % If distance is less than 10 cm detection occurs and Control System starts
        
            if(distance < 10)
        
                disp(distance);
        
                % --------------------- Control System Execution --------------------------
        
                c(k) = 0.0392 * m(k-1) + 0.9842 * c(k-1);
                e(k) = r(1) - c(k); % r(1) is r(k)
                m(k) = 1/2 * ((2 * kp + ki * T) * e(k) + (ki * T - 2 * kp) * e(k-1)) + m(k-1);
            
                str_data = num2str(c(k));
                str_values = ' Liters / Minute';
                str_print = append(str_data, str_values);
            
                str_setpoint_is = 'Current Water Flow Set Point is: ';
                str_setpoint = num2str(setpoint);
                str_print_setpoint = append(str_setpoint_is, str_setpoint, str_values);
            
                figure(1);
                plot(x(1:k),c(1:k),'--b',t,r,'-r');
                xlabel('Iterations');
                ylabel('Water Flow (L / m)');
                xline(k - 30);
                yline(0);
                legend({'Water Flow Output','Setpoint','X axis', 'Y axis'},'Location','southeast');
                text(max(x(k)),max(c(k)),str_print);
                text(max(k - 18),6,str_print_setpoint);
                title('System Response');
                xlim([k-40 k+20]);
                ylim([-1 7]);
        
                % Un-comment for Error and Manipulation Graphs
                %{
                figure(2);
                subplot(2,1,1),plot(x(1:k),e(1:k),'-r');
                xlabel('Iterations');
                ylabel('Error Signal');
                legend({'Error Signal','X axis', 'Y axis'},'Location','southeast');
                text(max(x(k)),max(e(k)),num2str(e(k)));
                title('Error Signal');
                xline(k - 30);
                yline(0);
                xlim([k-40 k+20]);
                ylim([-1 7]);
        
                subplot(2,1,2),plot(x(1:k),m(1:k),'-g');
                xlabel('Iterations');
                ylabel('Controller Signal');
                legend({'Controller Signal','X axis', 'Y axis'},'Location','southeast');
                text(max(x(k)),max(m(k)),num2str(m(k)));
                title('Controller Signal');
                xline(k - 30);
                yline(0);
                xlim([k-40 k+20]);
                ylim([-1 7]);
                %}
        
                drawnow;
            
                % System Refreshing occurs every 0.1 seconds
            
                pause(0.1);
            
                % ---------- System Behavior ---------------
            
                water_flow_output = c(k);
            
                % If Water Flow Output has reached less than 50 mililiters per minute,
                % system stops. This creates an event and alerts the user on the IoT
                % Application that they have reached their daily maximum.
            
                if(water_flow_output < 0.05)
                    response_finished_complete = webread(api_url_finished);
                    break;
                end
            
                % Consumed water in 0.1 seconds // Water Flow is measured in Liters /
                % minute, therefore a simple 3 rule having 600 decimal seconds in a
                % minute:
            
                water_consumption = water_flow_output / 600;
            
                % Relational water decrease
            
                water_decrease_ratio = water_consumption / water_limit; % If 1%, this holds 0.001 (not multiplied times 100)
            
                % Water Decrease
            
                water_limit = water_limit - water_consumption;
            
                % New Water Flow Setpoint relative to water decrease
            
                setpoint = setpoint - (setpoint * water_decrease_ratio);
            
                r = zeros(n,1) + setpoint; % New Water Flow Set Point
        
                % Send Total Number of Liters Left to IoT Web Server
        
                base_api_url_liters = "http://localhost:2000/api/set-remaining-liters/";
        
                url_liters = num2str(water_limit);
        
                full_api_url_liters = append(base_api_url_liters, url_liters);
        
                response_liters = webread(full_api_url_liters);
            
                % K increase for next iteration
            
                k = k + 1;
        
            end
        end
    end
end

