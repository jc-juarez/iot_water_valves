% Tecnológico de Monterrey
% Computerized Control Final Project
% IoT Water Valves
% Matlab Server

% Predefined values
clc;
T = 0.1;
n = 1000000; % Predefined Value for Plot in X-axis

% Initial Water Flow of 5 Liters per Minute

setpoint = 5;

r = zeros(n,1) + setpoint; % Starts at 5 Liters per minute


% Tuning Values

kp = 0.5;
ki = 1;

% Initial Values for non Zero Indexing (Only c(k) and e(k))

c(1) = 0;
e(1) = r(1) - c(1); % r(1) is r(1)
m(1) = 1/2 * ((2 * kp + ki * T) * e(1));

c(2) = 0.04004 * m(1) + 1.4563 * c(1);
e(2) = r(1) - c(2); % r(1) is r(2)
m(2) = 1/2 * ((2 * kp + ki * T) * e(2) + (ki * T - 2 * kp) * e(1)) + m(1);

% -------------------------------------------------

% 1 - PI with Bilinear Transformation

% Initial Values for m(k)

% Loop


figure;

k = 3;
t = 1:n;
x = 1:n;

% While True: This Loop would work in an infinite manner if the plot of the
% output is not needed. The plot restricts it from being infinite because
% of two reasons:
% 1. The plot needs a defined x-value on which it will plot, therefore this
% needs to be a predefined constant value that cannot be exceeded.
% 2. The plot requires persistent dynammic programming for keeping all
% arrays values and displaying them. If no plot is needed, only 3 arrays 
% with constant sizes can be defined an memory overriding with a dynammic 
% programming approach could be used, making the system run in a seamless 
% infinite way.

% System Refreshes every 0.1 seconds

water_limit = 0.3;

while 10 > 1

    c(k) = 0.04004 * m(k-1) + 0.0322 * m(k-2) + 1.4563 * c(k-1) - 0.522 * c(k-2);
    e(k) = r(1) - c(k); % r(1) is r(k)
    m(k) = 1/2 * ((2 * kp + ki * T) * e(k) + (ki * T - 2 * kp) * e(k-1)) + m(k-1);

    str_data = num2str(c(k));
    str_values = ' Liters / Minute';
    str_print = append(str_data, str_values);

    str_setpoint_is = 'Current Water Flow Set Point is: ';
    str_setpoint = num2str(setpoint);
    str_print_setpoint = append(str_setpoint_is, str_setpoint, str_values);

    plot(x(1:k),c(1:k),'--b',t,r,'-r');
    text(max(x(k)),max(c(k)),str_print);
    text(max(k - 18),6,str_print_setpoint);
    xline(k - 30);
    yline(0);
    xlim([k-40 k+20]);
    ylim([-1 7]);

    drawnow;

    % System Refreshing occurs every 0.1 seconds

    pause(0.1);

    % ---------- System Behavior ---------------

    water_flow_output = c(k);

    % If Water Flow Output has reached less than 10 mililiters per minute,
    % system stops. This creates an event and alerts the user on the IoT
    % Application that they have reached their daily maximum.

    if(water_flow_output < 0.01)
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

    % K increase for next iteration

    k = k + 1;

end








