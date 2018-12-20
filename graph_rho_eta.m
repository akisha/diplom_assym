function [graph_rho, graph_eta] = graph_rho_eta(omega, t)
beta = 0.03;
a0 = (1.1 * 1.1 + beta ^ 2 ) * (0.9 * 0.9 + beta ^ 2);
a1 = 2 * beta * (1.1 * 1.1 + 0.9 * 0.9 + 2 * beta ^ 2);
a2 = 1.1 * 1.1 + 0.9 * 0.9 + 6 * beta ^ 2;
a3 = 4 * beta;
A = [0 1 0 0; 0 0 1 0; 0 0 0 1; -a0 -a1 -a2 -a3];
B = [0; 0; 0; 1];
C = [0 0 -1 0];

for lam_cnt = 1 : length(t)
    t_curr = t (lam_cnt);
    f_rho = frho (A, B, C, omega, t_curr);
    f_eta = feta (A, B, C, omega, t_curr);
    rho(lam_cnt) = f_rho;
    eta(lam_cnt) = f_eta;
end

graph_eta = eta;
graph_rho = rho;