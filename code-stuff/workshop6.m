% Dylan Qiu Workshop 6 
% Matlab for Mass Spring || Damper System
clc; clear; close all;

% Parameters
m = 0.5;          % Mass (kg)
c = 1.2665*10^-6;        % compliance constant (m/N)
R = 10;        % Damping coefficient (kg/s)
k = 1/ c;          % spring constant

% derived parameters
wn = sqrt(1/(m*c));

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
N1 = 500000;
dw = 0.01;
w = (0:N1-1).'*dw;

% Velocity and position vectors
v = impulse(V,t);
x = impulse(X,t);

% Admittance In terms of \omega

y = 1 ./ (R + k ./(1i*w) + 1i*w*m);
H = X / F; 
bode(H)

% Part (c): Base case plots for v(t) and x(t)
figure('Name', 'Part (c)');
subplot(2,1,1);
plot(t, v, 'LineWidth', 3); grid on;
title('Velocity Response v(t)');
ylabel('v(t) (m/s)');

subplot(2,1,2);
plot(t, x, 'LineWidth', 3); grid on;
title('Position Response x(t)');
xlabel('Time (s)'); ylabel('x(t) (m)');

% Part (d): Base case plot for Admittance Y(w)
figure('Name', 'Part (d)');
semilogx(w, abs(y), 'LineWidth', 2); grid on;
title('Admittance Magnitude |Y(\omega)|');
xlabel('Frequency (rad/s)'); ylabel('|Y(\omega)|');

% Part (e): Varying R
R_vec = 5:5:25; % Adjusted range for clarity
figV = figure; hold on; grid on; title('v(t) for varying R');
figX = figure; hold on; grid on; title('x(t) for varying R');
figY = figure; hold on; grid on; title('|Y(\omega)| for varying R');

for j = 1:length(R_vec)
    R_val = R_vec(j);
    
    % Define Impedance and Admittance Transfer Functions
    Z_s = m*s + R_val + k/s;
    Y_tf = 1/Z_s;
    
    % Responses with Initial Conditions
    V_s = (m*v0 - k*x0/s) * Y_tf;
    X_s = V_s/s + x0/s;
    H_s = Y/s;
    
    v_r = impulse(V_s, t);
    x_r = impulse(X_s, t);
    %h_w = impulse(H_s, w);
    y_w_r = 1 ./ (R_val + 1i*w*m + k./(1i*w));
    
    figure(figV); plot(t, v_r, 'LineWidth', 2, 'DisplayName', ['R = ', num2str(R_val)]);
    figure(figX); plot(t, x_r, 'LineWidth', 2, 'DisplayName', ['R = ', num2str(R_val)]);
    figure(figY); semilogx(w, abs(y_w_r), 'LineWidth', 2, 'DisplayName', ['R = ', num2str(R_val)]);
    bode(H_s,w);
end

figure(figV); xlabel('Time (s)'); ylabel('v(t)'); legend show;
figure(figX); xlabel('Time (s)'); ylabel('x(t)'); legend show;
figure(figY); xlabel('Frequency (rad/s)'); ylabel('|Y(\omega)|'); legend show;


% Part (f): Varying C
C_vec = [0.5e-6, 1.2665e-6, 5e-6, 1e-5]; 
figVf = figure; hold on; grid on; title('v(t) for varying C');
figXf = figure; hold on; grid on; title('x(t) for varying C');
figYf = figure; hold on; grid on; title('|Y(\omega)| for varying C');

for j = 1:length(C_vec)
    C_val = C_vec(j);
    k_val = 1/C_val;
    
    % Laplace Domain Models
    Z_c = s*m + k_val/s + 10; % Using R = 10
    V_c = inv(Z_c) * (m*v0 - k_val*x0/s);
    X_c = V_c/s + x0/s;
    
    % Time Domain Simulation
    v_t_c = impulse(V_c, t);
    x_t_c = impulse(X_c, t);
    
    % Frequency Domain Admittance
    y_w_c = 1 ./ (10 + 1i*w*m + k_val./(1i*w));
    
    % Plotting
    figure(figVf);
    plot(t, v_t_c, 'LineWidth', 1.5, 'DisplayName', ['C = ', num2str(C_val)]);
    
    figure(figXf);
    plot(t, x_t_c, 'LineWidth', 1.5, 'DisplayName', ['C = ', num2str(C_val)]);
    
    figure(figYf);
    semilogx(w, abs(y_w_c), 'LineWidth', 2, 'DisplayName', ['C = ', num2str(C_val)]);
end

% Finalize plots
figure(figVf); xlabel('Time (s)'); ylabel('v(t)'); legend show;
figure(figXf); xlabel('Time (s)'); ylabel('x(t)'); legend show;
figure(figYf); xlabel('Frequency (rad/s)'); ylabel('|Y(\omega)|'); 
ylim([0 0.2]); legend show;

%% Dylan Qiu - ME 301 Workshop 6 Problem 2
% Givens 
r1 = 0.5; r2 = 0.3;  %m
m = 10; % kg
k1 = 200; k2 = 300; k3 = 500; %N/m

R_val = 10; %kg/s

% Equivalent Inertia about the contact point
Jeff = (3/2) * m * r1^2;

% Initial conditions

theta0 = 0.15; %radians

% derived values
x1 = r2 * theta0;
x2 = k2 * x1 / (k2+k3); 
r_eq = r1 + r2; % Distance from ground contact to spring line

s = tf('s');

% Time vector 
N = 1000;
dt = 0.01;
t = (0:N-1).'*dt;

% Linear Mesh solution

% Initial Condition Forces
F1 = (k1 * x1)/s;
F2 = (k2 * (x2-x1))/s;
F3 = (k3 * x2)/s;
m_eq = Jeff / (r_eq)^2;

% Force Vector 
F_vec = [-F1 + F2; -F2 - F3];

% Impedance Matrix Z
Z_b = [(m_eq*s + k1/s + k2/s), -k2/s;
      -k2/s, (k2/s + k3/s) ];

% Solve for Mesh Velocities V = [v1; v2]
V_vec = inv(Z_b) * F_vec;

% Extracting Velocity and Displacement for Mesh 1
v1_t = impulse(V_vec(1), t); 
x1_t = impulse(V_vec(1)/s + x1/s, t);

% Plotting
figure;
subplot(2,1,1); plot(t, v1_t, 'b', 'LineWidth', 1.5); grid on;
ylabel('v_1(t) [m/s]'); title('V(t) (no damping)');
subplot(2,1,2); plot(t, x1_t, 'r', 'LineWidth', 1.5); grid on;
ylabel('x_1(t) [m]'); xlabel('Time (s)'); title('X(t)');

% Part C 

% Impedance and force Matrix 
F_vec_c = [-F1 ; 0];
Z_c = [(m_eq*s + k1/s + R), -R;
       -R,      (R + k3/s) ];

% Solve for Mesh Velocities V = [v1; v2]
V_vec_c = inv(Z_c) * F_vec_c;

% Extracting Velocity and Displacement for Mesh 1
v1_t_c = impulse(V_vec_c(1), t); 
x1_t_c = impulse(V_vec_c(1)/s + x1/s, t);

% Plotting
figure;
subplot(2,1,1); plot(t, v1_t_c, 'b', 'LineWidth', 1.5); grid on;
ylabel('v_1(t) [m/s]'); title('Velocity v(t) With Damper');
subplot(2,1,2); plot(t, x1_t_c, 'r', 'LineWidth', 1.5); grid on;
ylabel('x_1(t) [m]'); xlabel('Time (s)'); title('Position x(t) With Damper');