% Dylan Qiu ME'27
% ME301, MDOF In Class Wksp 
clear; clc; close all;

% Parameters 
m1 = 10;               % Mass of empty washing machine (kg)
m2 = 15;                 % Mass of clothes (kg)

k1 = 20;                   % Stiffness (N/m)
k2 = 24;
k3 = 22;

R = 0.01;                     % Damping coefficient (kg/s)

N = 10000; 
df = 0.01;
w = (0:N-1).'*df;

% --- Transfer Functions ---
s = tf('s');
Z = [s * m1 + k1 / s + R + k2/s + R, -(R + k2/s);
    -(R + k2/s), s * m2 + k2 / s + R + k3/s + R]; 

% admittance and FRF
Y = inv(Z); 
FRF = Y / s;

% Plot
figure(1);
bodemag(Y,w);
title('Admittance Y');
figure(2);
bodemag(FRF,w);
title('FRF (\omega)');
