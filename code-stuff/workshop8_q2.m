% ME301, Rotating Unbalance - Workshop 8, Problem 2
clear; clc; close all;
% --- Parameters ---
m_machine = 76;               % Mass of empty washing machine (kg)
m_load = 4;                 % Mass of clothes (kg)

k = 60e3;                   % Stiffness (N/m) - converted from 60 kN/m
R = 10;                     % Damping coefficient (kg/s)
r = 0.25;                   % Eccentricity / offset radius (m)

rpm = 850;                  % Rotational speed (RPM)
wf = rpm * (2*pi / 60);     % Forcing frequency (rad/s)

dt = 0.001;
N = 1000;
t = (0:N-1).'*dt;

% --- Transfer Functions ---
s = tf('s');

V_load = m_load* r * s^2 / (s^2+wf^2);

% c. System of equations / Impedance matrix
Z = [1,0;
    -s*m_load, s*(m_machine+m_load)+k/s+R]; 

% Force vector: Laplace transform of F0 * sin(wf * t)
F = [V_load;0];

% Solve for Velocity (V) and Displacement (X)
V = inv(Z) * F; 
X = V(2) / s;

% e. Admittance (Y) and Frequency Response Function (FRF)
Y = 1 / Z(2,2); 
FRF = Y / s;

% --- Time Domain Responses ---
% d. Plot displacement and velocity of the washing machine
v_t = impulse(V(2), t);
x_t = impulse(X, t);

% Plot
figure(1);
subplot(2,1,1);
plot(t, x_t, 'LineWidth', 1.5);
title('d. Washing Machine Displacement x(t)');
xlabel('Time (s)');
ylabel('Displacement (m)');
grid on;

% Part D: Time Domain - Velocity
subplot(2,1,2);
plot(t, v_t, 'LineWidth', 1.5, 'Color', 'r');
title('d. Washing Machine Velocity v(t)');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
grid on;

% Part E: Frequency Domain - Admittance
figure(3);
bodemag(Y);
title('e. Magnitude of Admittance (Y)');
grid on;

% Part E: Frequency Domain - FRF
figure(4)
bodemag(FRF);
title('e. Magnitude of Frequency Response Function (FRF)');
grid on;