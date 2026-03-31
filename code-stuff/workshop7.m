% Dylan Qiu Workshop 7
% Workshop 7, Problem 1: Mass-Spring-Damper System Responses
clc; clear; close all;

% System Parameters
m = 1;          % Mass (kg)
k = 200;        % Spring constant (N/m)
R = 0.1;        % Damping coefficient (kg/s)
t0 = 0.5;       % Delay time (s)
wf = 10;        % Assuming a frequency for the sine wave (part e)

% Define Laplace variable 's'
s = tf('s');

% Impedance and System Transfer Functions
Z = s * m + k/s + R;    % Impedance Matrix Z(s)

% Define Forcing Functions F(s) purely in the Laplace domain

% a. f(t) = delta(t - t0) -> F(s) = e^(-s*t0)
Fa = exp(-s*t0);

% b. f(t) = 0.2*delta(t) + 0.05*delta(t - t0) -> F(s) = 0.2 + 0.05*e^(-s*t0)

Fb = 0.2 + 0.05*exp(-t0*s);

% c. f(t) = u(t - t0) -> F(s) = (1/s) * e^(-s*t0)
Fc = 1/s * exp(-s*t0);

% d. f(t) = e^(0.5t) * u(t - t0) -> F(s) = [e^(0.5*t0) / (s - 0.5)] * e^(-s*t0)
Fd = exp(0.5*t0) * exp(-s*t0)/ (s - 0.5);

% e. f(t) = piecewise ramp to sine
% F(s) = 1/s^2 - e^(-s*t0)*(t0*s + 1)/s^2 + e^(-s*t0)*(s*sin(wf*t0) + wf*cos(wf*t0))/(s^2 + wf^2)
Fe_term1 = 1/s^2;

Fe_term2 = -(t0*s + 1)/s^2;
Fe_term2.InputDelay = t0;

Fe_term3 = (sin(wf*t0)*s + wf*cos(wf*t0)) / (s^2 + wf^2);
Fe_term3.InputDelay = t0;

Fe = Fe_term1 + Fe_term2 + Fe_term3;

% Store inputs in a cell array for clean looping
F_inputs = {Fa, Fb, Fc, Fd, Fe};
titles = {'a) \delta(t-t_0)', 'b) 0.2\delta(t) + 0.05\delta(t-t_0)', ...
          'c) u(t-t_0)', 'd) e^{0.5t}u(t-t_0)', 'e) piecewise'};

% Time vector for simulation
N = 10000;
dt = 0.001;
t = (0:N-1).'*dt;

% Simulate and Plot
for i = 1:5
    F = F_inputs{i};

    V_out = inv(Z) * F;
    %X_sys = V_out/s;        % Transfer function for Position: X(s)/F(s)
    [v, t_out] = impulse(V_out, t);
    
    if i == 2 || i == 5
        % Part b: Calculate position by numerically integrating velocity
        x = cumtrapz(t_out, v);
    else
        % All other parts: Calculate position using the position transfer function
        X_out = V_out/s;
        [x, ~] = impulse(X_out, t);
    end
    
    figure('Name', ['Part ', num2str(i)]);
    
    % Plot Velocity
    subplot(2,1,1);
    plot(t_out, v, 'LineWidth', 1.5);
    title(['Velocity Response: ', titles{i}]); grid on;
    xlabel('Time (s)');
    ylabel('Velocity (m/s)');
    legend('v(t)');
    
    % Plot Position
    subplot(2,1,2);
    plot(t_out, x, 'LineWidth', 1.5);
    title(['Position Response: ', titles{i}]); grid on;
    xlabel('Time (s)');
    ylabel('Position (m)');
    legend('x(t)');
end

