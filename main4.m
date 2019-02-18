clc
clear
format long;

lam_min = 0.01;
lam_max = 0.4999;
num_points = 10000;
t = linspace(lam_min, lam_max, num_points);
step = 0.02;
omega_min = 0.64;
omega_max = 0.7;


[omega_1, omega_2] = interval(step, omega_min, omega_max, t);
omega_1
omega_2