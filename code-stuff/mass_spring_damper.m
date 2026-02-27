% Dylan Qiu In class work shop Matlab for Mass Spring || Damper System
clc; clear; close all;
% Parameters
m = 1;          % Mass (kg)
k = 4.8;        % Spring constant (N/m)
R = 1.1;        % Damping coefficient (kg/s)

% Init Conds

v0 = 0; % m/s
x0 = 2/100; % m 
s = tf('s');
% Force Vector
Fm = m*v0;
Fk = k * x0/s;
F = [Fm-Fk];

% Impedence Matrix
 
Z = s * m + k/s + R; 

V = inv(Z) .* F;
X = V/s + x0/s;
% Time vector for simulation
N = 10000;
dt = 0.001;
t = (0:N-1).'*dt;

% Velocity
v = impulse(V,t);
x = impulse(X,t);
% Plotting the result
figure;
plot(t, v);
title('Velocity Response v(t)'); grid on;
xlabel('Time (s)');
ylabel('Velocity (m/s)');
legend('v(t)');

figure;
plot(t, x);
title('Position Response v(t)'); grid on;
xlabel('Time (s)');
ylabel('position (m)');
legend('x(t)');