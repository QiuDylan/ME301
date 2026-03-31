% Dylan Qiu, ME '27, ME301 Workshop 3
% Problem 1, Cylinder with Spring and Damper
clc; clear; close all;

% Givens
J  = 0.75;      % (kg*m^2)
R  = 6;         % (kg/s)
k  = 40000;     % (N/m)
r1 = 0.23;      % (m)
r2 = 0.08;      % (m)

% Initial Conditions
theta0 = 0.1;       %(rad)
theta_dot0 = 0.01;  % (rad/s)

% Time Simulation
dt = 0.01; 
N = 10000; 
T = dt * N; % period in sec
t = (0:dt:(N-1)*dt)'; % time vector 


% Calculated Constants 
K_eff = k * r1^2;           % Effective torsional stiffness
C_eff = R * r2^2;           % Effective torsional damping
wn = sqrt(K_eff / J);       % Natural frequency (rad/s)
zeta = C_eff / (2 * J * wn); % Damping ratio
beta = zeta * wn;           % Damping coefficient (Ns/m)
wd = sqrt(wn^2 - beta^2); % Damped frequency (rad/s)

% Analytical solution for system
% theta(t) = exp(-beta*t) * (A*cos(wd*t) + B*sin(wd*t))
A = theta0;
B = (theta_dot0 + beta * theta0) / wd;

theta = exp(-beta * t) .* (A * cos(wd * t) + B * sin(wd * t));
theta_dot = -beta * exp(-beta * t) .* (A * cos(wd * t) + B * sin(wd * t)) +... 
exp(-beta * t) .* (- A* wd * sin(wd * t) + B * wd* cos(wd * t)) ;

% Plotting 
figure();

% Theta plot
subplot(2,1,1);
plot(t, theta, 'LineWidth', 1);
grid on;
title('System Response: \theta(t)');
ylabel('Displacement (rad)');
xlabel('Time (s)');

% Theta_dot plot
subplot(2,1,2);
plot(t, theta_dot, 'r', 'LineWidth', 1);
grid on;
title('System Response: \theta''(t)');
ylabel('Velocity (rad/s)');
xlabel('Time (s)');