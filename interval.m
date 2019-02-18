function [omega_1, omega_2] = interval(step, omega_min, omega_max, t)
beta = 0.03;
a0 = (1.1 ^ 2 + beta ^ 2 ) * (0.9 ^ 2 + beta ^ 2);
a1 = 2 * beta * (1.1 ^ 2 + 0.9 ^ 2 + 2 * beta ^ 2);
a2 = 1.1 ^ 2 + 0.9 ^ 2 + 6 * beta ^ 2;
a3 = 4 * beta;
A = [0 1 0 0;
    0 0 1 0;
    0 0 0 1;
    -a0 -a1 -a2 -a3];
B = [0; 0; 0; 1];
C = [0 0 -1 0];

number_of_intervals = 0;
omega_curr = omega_min;
lam_points = length(t);

for lam_curr = 1 : lam_points
    t_curr = t (lam_curr);
    f_rho = frho (A, B, C, omega_curr , t_curr);
    f_eta = feta (A, B, C, omega_curr , t_curr);
    graph_rho_prev(lam_curr) = f_rho;
    graph_eta_prev(lam_curr) = f_eta;
end
diff_rho_eta_prev = graph_rho_prev - graph_eta_prev;
num_of_intersections_prev = num_of_int(diff_rho_eta_prev);
[~, diff_min_index_prev] = min(abs(diff_rho_eta_prev));
if (graph_rho_prev(diff_min_index_prev) * graph_eta_prev(diff_min_index_prev) < 0)
   different_sign_prev = true;  
   x1 = [t(diff_min_index_prev), graph_rho_prev(diff_min_index_prev)];
   y1 = [t(diff_min_index_prev + 1), graph_rho_prev(diff_min_index_prev + 1)];
   x2 = [t(diff_min_index_prev), graph_eta_prev(diff_min_index_prev)];
   y2 = [t(diff_min_index_prev + 1), graph_eta_prev(diff_min_index_prev + 1)];
   if (graph_eta_prev(diff_min_index_prev) * graph_eta_prev(diff_min_index_prev + 1) > 0)
       y1 = [t(diff_min_index_prev - 1), graph_rho_prev(diff_min_index_prev - 1)];
       y2 = [t(diff_min_index_prev - 1), graph_eta_prev(diff_min_index_prev - 1)] ;
   end
   p1 = polyfit(x1, y1, 1);
   p2 = polyfit(x2, y2, 1);
   x_intersect_prev = roots(p1 - p2);
   y_intersect_prev = polyval(p1, x_intersect_prev);
else different_sign_prev = false;
end


while omega_curr <= omega_max
    omega_curr
    omega_next = omega_curr + step
    for lam_curr = 1 : lam_points
        t_curr = t (lam_curr);
        f_rho = frho (A, B, C, omega_next, t_curr);
        f_eta = feta (A, B, C, omega_next, t_curr);
        graph_rho_next(lam_curr) = f_rho;
        graph_eta_next(lam_curr) = f_eta;
    end
    diff_rho_eta_next = graph_rho_next - graph_eta_next;
    num_of_intersections_next = num_of_int(diff_rho_eta_next);
    if (num_of_intersections_prev == 1) && (num_of_intersections_next == 1)
        [~, diff_min_index_next] = min(abs(diff_rho_eta_next));
        if different_sign_prev && (graph_eta_next(diff_min_index_next) * graph_rho_next(diff_min_index_next) < 0)
            x1 = [t(diff_min_index_next), graph_rho_next(diff_min_index_next)];
            y1 = [t(diff_min_index_next + 1), graph_rho_next(diff_min_index_next + 1)];
            x2 = [t(diff_min_index_next), graph_eta_next(diff_min_index_next)];
            y2 = [t(diff_min_index_next + 1), graph_eta_next(diff_min_index_next + 1)];
            if (graph_eta_next(diff_min_index_next) * graph_eta_next(diff_min_index_next + 1) > 0)
                y1 = [t(diff_min_index_next - 1), graph_rho_next(diff_min_index_next - 1)];
                y2 = [t(diff_min_index_next - 1), graph_eta_next(diff_min_index_next - 1)] ;
            end
            p1 = polyfit(x1, y1, 1);
            p2 = polyfit(x2, y2, 1);
            x_intersect_next = roots(p1 - p2);
            y_intersect_prev
            y_intersect_next = polyval(p1, x_intersect_next)
            if y_intersect_prev * y_intersect_next < 0
                number_of_intervals = number_of_intervals + 1;
                omega_1(number_of_intervals) = omega_curr;
                omega_2(number_of_intervals) = omega_next;
            end
            y_intersect_prev = y_intersect_next;
            different_sign_prev = true;
        else 
            different_sign_prev = false;
        end
    end
    num_of_intersections_prev = num_of_intersections_next;
    graph_rho_prev = graph_rho_next;
    graph_eta_prev = graph_eta_next;
    diff_min_index_prev = diff_rho_eta_next;
    omega_curr = omega_curr + step;
end
end