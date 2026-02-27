% Dylan Qiu Workshop 6 
% %Matlab for Mass Spring || Damper System
clc; clear; close all;

% Parameters
m = 0.5;          % Mass (kg)
c = 1.2665*10^-6;        % compliance constant (m/N)
R = 10;        % Damping coefficient (kg/s)
k = 1/ c; % spring constant


% Init Conds

v0 = 1; % m/s
x0 = 0.3; % m 
s = tf('s');

% Force Vector

Fm = m*v0;
Fk = k * x0/s;
F = [Fm-Fk];

% Impedence / Admittance
Z = s * m + k/s + R; 
Y = inv(Z);

V = inv(Z) .* F;
X = V/s + x0/s;
% Time vector for simulation
N = 100;
dt = 0.001;
t = (0:N-1).'*dt;

% omega vector for simulation
N1 = 1000000;
dw = 0.01;
w = (0:N1-1).'*dw;

% Velocity
v = impulse(V,t);
x = impulse(X,t);

% Admittance In terms of \omega

y = 1 ./ (R + k ./(1i*w) + 1i*w*m);
%bode(Y)

% Changing R 
R_vec = 0:2:20; %Changing Resistance vector


% Initialize Figures
figV = figure; hold on; grid on; title('Velocity Response v(t) for varying R');
figX = figure; hold on; grid on; title('Position Response x(t) for varying R');
figY = figure; hold on; grid on; title('Admittance Magnitude |Y(\omega)| for varying R');

for j = 1:length(R_vec)
    R = R_vec(j);
    s = tf('s');
    
    % Define Impedance and Admittance
    Z = m*s + R + k/s;
    Y_s = 1/Z;
    
    % System Response considering initial conditions
    % V(s) = (m*v0 - k*x0/s) / Z
    V_s = (m*v0 - k*x0/s) * Y_s;
    % X(s) = V(s)/s + x0/s
    X_s = V_s/s + x0/s;
    
    % Time Domain Simulation
    [v, ~] = impulse(V_s, t);
    [x, ~] = impulse(X_s, t);
    
    % Frequency Domain Admittance
    % Y(w) = 1 / (R + i*w*m + k/(i*w))
    y_w = 1 ./ (R + 1i*w*m + k./(1i*w));
    
    % Plotting Velocity
    figure(figV);
    plot(t, v, 'LineWidth', 1.5, 'DisplayName', ['R = ', num2str(R)]);
    
    % Plotting Position
    figure(figX);
    plot(t, x, 'LineWidth', 1.5, 'DisplayName', ['R = ', num2str(R)]);
    
    % Plotting Admittance
    figure(figY);
    semilogx(w, abs(y_w), 'LineWidth', 1.5, 'DisplayName', ['R = ', num2str(R)]);
end

% Formatting Plots
figure(figV); xlabel('Time (s)'); ylabel('v(t) (m/s)'); legend show;
figure(figX); xlabel('Time (s)'); ylabel('x(t) (m)'); legend show;
figure(figY); xlabel('Frequency (rad/s)'); ylabel('|Y(\omega)|'); legend show;


% 
% % Plotting the result
% figure;
% plot(t, v);
% title('Velocity Response v(t)','LineWidth', 3); grid on;
% xlabel('Time (s)');
% ylabel('Velocity (m/s)');
% legend('v(t)');
% 
% figure;
% plot(t, x);
% title('Position Response v(t)','LineWidth', 3); grid on;
% xlabel('Time (s)');
% ylabel('position (m)');
% legend('x(t)');
% 
% figure;
% plot(w, abs(y),'LineWidth', 3);
% title('Admitance Response Y(\omega)'); grid on;
% xlabel('Frequency (\omega)');
% ylabel('Admittance (s/kg)');
% ylim([0 1/R + 0.001]);
% %legend('x(t)');
