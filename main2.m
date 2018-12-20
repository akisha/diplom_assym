clc
clear
format long;

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

lam_min = 0.01;
lam_max = 0.4999;
num_points = 10000;
t = linspace(lam_min, lam_max, num_points);

omega_min = 0.1;
omega_max = 9;
threshold = 1e-2;

%Result is w = 0.672577667236328
while (omega_max - omega_min > threshold)
    omega_curr = (omega_max + omega_min) / 2;
    for lam_cnt = 1 : num_points
        t_curr = t (lam_cnt);
        f_rho = frho (A, B, C, omega_curr , t_curr);
        f_eta = feta (A, B, C, omega_curr , t_curr);
        graph_rho(lam_cnt) = f_rho;
        graph_eta(lam_cnt) = f_eta;
    end
    diff_rho_eta = graph_rho - graph_eta;
    [~, diff_min_index] = min(abs(diff_rho_eta));
    num_of_intersections = num_of_int(diff_rho_eta);
    if (num_of_intersections == 1)
        % If closest points x1 and x2 have different sign
        if (graph_rho(diff_min_index) * graph_eta(diff_min_index) < 0)
            % search for intersection point of the lines x1y1 and x2y2 ,
            % where y1 and y2 - points after
            % x1 and y1 in graph_rho and graph_eta
            x1 = [t(diff_min_index), graph_rho(diff_min_index)];
            y1 = [t(diff_min_index + 1), graph_rho(diff_min_index + 1)];
            x2 = [t(diff_min_index), graph_eta(diff_min_index)];
            y2 = [t(diff_min_index + 1), graph_eta(diff_min_index + 1)];
            % define where was the intersection ( left or right )
            if (graph_eta(diff_min_index) * graph_eta(diff_min_index + 1) > 0)
                y1 = [t(diff_min_index - 1), graph_rho(diff_min_index - 1)];
                y2 = [t(diff_min_index - 1), graph_eta(diff_min_index - 1)] ;
            end
            p1 = polyfit(x1, y1, 1);
            p2 = polyfit(x2, y2, 1);
            x_intersect = roots(p1 - p2);
            y_intersect = polyval(p1, x_intersect);
            % if sign is positive, then it is assumed that intersection
            % is above the 0
            if (y_intersect > 0)
                omega_max = omega_curr;
            elseif (graph_rho(diff_min_index) < 0)
                    omega_min = omega_curr;
            else
                break;
            end
        else
            if ((abs(graph_rho(diff_min_index)) < threshold) && (abs(graph_eta(diff_min_index)) < threshold))
                break;
            else
                if (graph_rho(diff_min_index) > 0)
                    omega_max = omega_curr;
                elseif (graph_rho(diff_min_index) < 0)
                    omega_min = omega_curr;
                else
                    break;
                end
            end
        end
    elseif (num_of_intersections > 1)
        omega_min = omega_curr;
    else 
        omega_max = omega_curr;
    end
end
plot(t, graph_eta)
hold on
plot(t, graph_rho)
hold off
grid on
%можно ли пользоваться наблюдением, что количество пересчений rho и eta
%уменьшается с увеличением lambda