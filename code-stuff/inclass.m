% Dylan Qiu ME'27
% ME301, FFT In Class Wksp 
clc; clear; close all;

% Random Time Function
N = 10;
x = rand(N,1);

% Sampling frequency, dt and df 
fs = 10; %hz 
df = fs / N; 
dt = 1 / fs; 

% Time vector for simulation

t = (0:N-1).'*dt;

% Frequency vector for simulation
w = (0:N-1).'*df;

figure;
plot(t, x,'LineWidth', 3);


% FFT then plot 
X = fft(x) * dt;

figure;
plot(w, abs(X),'LineWidth', 3);
xlabel('time (s)'); ylabel('x(t)');

%% Inclass Forcing frequency stuff

% Parameters
m = 0.1;          % (kg)
k = 12;        % (N/m)
R = 0.1;        % Damping coefficient (kg/s)

% initial conds
f0 = 1;        
s = tf('s');

wn = sqrt(k/m);
wf = [1, 10 * wn, 2 * wn, wn + 1, wn]; % forcing frequencies rad/s

% Time vector for simulation
N = 10000;
dt = 0.001;
t = (0:N-1).'*dt;

% Setup Velocity Subplot (Top)
axV = subplot(2,1,1); 
hold(axV, 'on'); grid(axV, 'on');
title(axV, 'v(t) for varying \omega_f');
ylabel(axV, 'velocity (m/s)');

% Setup Position Subplot (Bottom)
axX = subplot(2,1,2); 
hold(axX, 'on'); grid(axX, 'on');
title(axX, 'x(t) for varying \omega_f');
ylabel(axX, 'position (m)');
xlabel(axX, 'Time (s)');

t = (0:N-1).'*dt;

for i = 1:length(wf)
    wf_n = wf(i);
    
    % Force and Impedance calculations
    F = [f0 * s / (s^2 + wf_n^2)];
    Z = s * m + k/s + R; 
    
    % Velocity and Position
    V = inv(Z) * F; 
    X = V/s; 
    
    v_r = impulse(V, t);
    x_r = impulse(X, t);
    
    % Plotting directly to the specific axes
    plot(axV, t, v_r, 'LineWidth', 1.5, 'DisplayName', ['\omega_f = ', num2str(wf_n)]);
    plot(axX, t, x_r, 'LineWidth', 1.5, 'DisplayName', ['\omega_f = ', num2str(wf_n)]);
end

legend(axV, 'show', 'Location', 'eastoutside');
legend(axX, 'show', 'Location', 'eastoutside');