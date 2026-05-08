%% Vibration Data Analysis - Peak Finding for Node 3
clear; clc; close all;

% 1. Load the data for this specific point 
data = load('Vibes - (.3) Beam - Tip 1.mat');
p = data.data;      
amp_accel = p(:, 1);  % Output (Beam Accelerometer)
amp_hammer = p(:, 2); % Input (Impact Hammer)
fs = data.fs;     
N = length(p);
dt =1 /fs;
t = (0:N-1).'*dt;

plot(t,data.data);
%%
df = fs / N; 
f = (0:N-1).'*df;
figure(1)
Y_accel = fft(amp_accel)*dt;
Y_hammer = fft(amp_hammer)*dt;
semilogx(f,20 * log10(abs(Y_accel)));
hold on;
semilogx(f,20 * log10(abs(Y_hammer)));
hold off;
xlim([0,fs/2]);

%%
H = Y_accel ./ Y_hammer; 
figure(2)
semilogx(f,20 * log10(abs(H)));
xlim([0,fs/2]);

%%
f_half = f(1:N/2);

% Calculate FRF (H) and truncate to positive frequencies
H = Y_accel ./ Y_hammer; 
H_half = H(1:N/2); 

[peaks, locs] = findpeaks(abs(H_half), 'MinPeakProminence', max(abs(H_half))*0.1);

im_H = imag(H);
locs(1) = [];
fns = f_half(locs).';
fprintf('The natural frequencies (rad/s) are:\n');
disp(fns);

%% plotting mode shapes
%pos = 0:length(wns); 

figure(4);
plot(f_half, abs(imag(H_half)), 'b', 'LineWidth', 1.2);
hold on;
plot(fns, abs(imag(H_half(locs))), 'ro', 'MarkerFaceColor', 'r');
title('Absolute Imaginary Part of Experimental FRF |Im(H)|');