% Dylan Qiu ME'27
% ME301, Workshop 10
clear; clc; close all;

% Parameters
m = 4000;      % kg 
k = 5e3;       % N/m 
R = 1;         % kg/s
Nf = 10000; 
df = 0.001;
w = (0:Nf-1).'*df;
s = tf('s');

% Impedance Matrix Z
Z = [s * m + (2*k)/s + 2*R, -(R + k/s), 0, 0;
    -(R + k/s), s * m + (2*k)/s + 2*R,-(R + k/s),0;
    0, -(R + k/s), s * m + (2*k)/s + 2*R,-(R + k/s);
    0,0,-(R + k/s),s * m + (k)/s + R;]; 
Y = inv(Z);    % Admittance Matrix
H = Y / s;     % Displacement FRF Matrix 

[re,im] = nyquist(H,w);

% Dynamic reshape method
n = size(im, 1);
cols = size(im, 2); % Changed from m to avoid overwriting building mass
im_2d = reshape(im, [n*cols, length(im)]).'; 

% Plotting
figure(2);
sgtitle('Imaginary Part of FRF');

subplot(2,2,1);
semilogx(w, im_2d(:,1), 'LineWidth', 1.5);
title('Im(H_{11})');
xlabel('\omega (rad/s)'); ylabel('Amplitude');
grid on;

subplot(2,2,2);
semilogx(w, im_2d(:,2), 'LineWidth', 1.5);
title('Im(H_{21})');
xlabel('\omega (rad/s)'); ylabel('Amplitude');
grid on;

subplot(2,2,3);
semilogx(w, im_2d(:,3), 'LineWidth', 1.5);
title('Im(H_{31})');
xlabel('\omega (rad/s)'); ylabel('Amplitude');
grid on;

subplot(2,2,4);
semilogx(w, im_2d(:,4), 'LineWidth', 1.5);
title('Im(H_{41})');
xlabel('\omega (rad/s)'); ylabel('Amplitude');
grid on;


re_2d = reshape(re, [n*cols, length(re)]).'; 

% Plotting the Real Part
figure(1);
sgtitle('Real Part of Displacement FRF');

subplot(2,2,1);
semilogx(w, re_2d(:,1), 'LineWidth', 1.5);
title('Re(H_{11})');
xlabel('\omega (rad/s)'); ylabel('Amplitude');
grid on;

subplot(2,2,2);
semilogx(w, re_2d(:,2), 'LineWidth', 1.5);
title('Re(H_{21})');
xlabel('\omega (rad/s)'); ylabel('Amplitude');
grid on;

subplot(2,2,3);
semilogx(w, re_2d(:,3), 'LineWidth', 1.5);
title('Re(H_{31})');
xlabel('\omega (rad/s)'); ylabel('Amplitude');
grid on;

subplot(2,2,4);
semilogx(w, re_2d(:,4), 'LineWidth', 1.5);
title('Re(H_{41})');
xlabel('\omega (rad/s)'); ylabel('Amplitude');
grid on;

%% Peak Finding & Mode Shapes
[~, locs] = findpeaks(-im_2d(:, 1));
locs(1) = [];
wns = w(locs).';
fprintf('The natural frequencies (rad/s) are:\n');
disp(wns);

%A = im_2d(locs, 1:n).';


%% 

pos = [0; 1; 2; 3; 4]; 

figure(3);

for ii = 1:length(wns)
    
    x = [0; A(:,ii)]; 

    subplot(2, 2, ii);
    plot(x, pos, 'Marker', '.', 'MarkerSize', 20, 'LineWidth', 1.5);
  
    title(sprintf('Mode %d (\\omega_n = %.2f rad/s)', ii, wns(ii)));
    xlim([-.4, .4]); 
    ylim([0, 4]);
    grid on;
    
end