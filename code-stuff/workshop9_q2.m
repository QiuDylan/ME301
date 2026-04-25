% Dylan Qiu ME'27
% ME301, Workshop 9 Problem 2
clear; clc; close all;

% Parameters 
m = 124;               % mass (kg) 
k1 = 1000;             % Stiffness (N/m) 
k2 = 3500;             % 
l = 2.6;               % length (m) 
J = (1/12) * m * l^2;  % MOI at COM

N = 100000; 
df = 0.001;
w = (0:N-1).'*df;
s = tf('s');

% Part A/C: Impedance Matrix 
Z = [(1/3)*m*s + k1/s, (1/6)*m*s; 
     (1/6)*m*s, (1/3)*m*s + k2/s]; 
Y = inv(Z);    
H = Y / s;     

%figure(1); bodemag(Y, w); title('Admittance Y (x1,x2)'); grid on;
%figure(2); bodemag(H, w); title('FRF H (x1,x2)'); grid on;

% Part D: Impedance Matrix 
Z_cm = [m*s + (k1+k2)/s,           (l/2)*(k2-k1)/s;
        (l/2)*(k2-k1)/s,           J*s + (l^2/4)*(k1+k2)/s]; 

Y_cm = inv(Z_cm);    
H_cm = Y_cm / s;     

%figure(3); bodemag(Y_cm, w); title('Admittance Y (CM)'); grid on;
%figure(4); bodemag(H_cm, w); title('FRF H (CM)'); grid on;