% Dylan Qiu ME'27
% ME301, wksp 9 question 1
clear; clc; close all;

% parameters
m1 = 10;               
m2 = 15;                 
k1 = 20; k2 = 24; k3 = 22;
R = 1; % up for anti resonance places

dt = 0.01;
N = 8000; 
t = (0:N-1).'*dt;
Nf = 10000; 
df = 0.01;
w = (0:Nf-1).'*df;

% Frequencies: w1, w2, wa1, wa2
w_vals = [1.29, 2.41, 1.75, 2.1]; 

% Transfer Functions
s = tf('s');
% Impedance Matrix Z
Z = [s * m1 + (k1+k2)/s + 2*R, -(R + k2/s);
    -(R + k2/s), s * m2 + (k2+k3)/s + 2*R]; 

Y = inv(Z);    % Admittance Matrix
H = Y / s;     % Displacement FRF Matrix

% Part A: Plotting Admittance and FRF
figure(1);
bodemag(Y, w); title('Admittance Y(\omega)'); grid on;

figure(2);
bodemag(H, w); title('FRF H(\omega)'); grid on;

% Part B: Forced Responses x(t)
% Defining the 8 specific cases
titles = {'i: f1=sin(w1t)', 'ii: f1=sin(w2t)', 'iii: f1=sin(w_a1t)', 'iv: f1=sin(w_a2t)', ...
          'v: f2=sin(w1t)', 'vi: f2=sin(w2t)', 'vii: f2=sin(w_a1t)', 'viii: f2=sin(w_a2t)'};

figure(3);
for i = 1:8
    % Select frequency and force location based on case index
    if i <= 4
        w_curr = w_vals(i);
        F = [w_curr/(s^2+w_curr^2); 0]; % Forcing mass 1
    else
        w_curr = w_vals(i-4);
        F = [0; w_curr/(s^2+w_curr^2)]; % Forcing mass 2 
    end
    
    % Displacement in Laplace: X = H * F
    X_s = H * F; 
    
    % Convert to time domain
    x_t = impulse(X_s, t); 
    
    % Plotting in separate figures
    figure(i + 2); % Starts at Figure 3
    plot(t, x_t(:,1), 'b', 'LineWidth', 1.5); hold on;
    plot(t, x_t(:,2), 'r', 'LineWidth', 1.5);
    
    title(titles{i});
    xlabel('Time (s)');
    ylabel('Displacement (m)');
    legend('x_1 (m_1)', 'x_2 (m_2)');
    grid on;
end


% Compute nyquist
[re,im] = nyquist(H,w);
im11 = squeeze(im(1,1,:));
im22 = squeeze(im(2,2,:));

figure(11);
plot(w,im11);
hold on;

plot(w,im22);
hold off; 