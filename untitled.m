function follow_path_3D_Ponly()
% سكريبت مبسط لجعل السيارة تتبع المسار باستخدام RK4
% تم دمج PD للدوران و PID للارتفاع بدون أي إضافات أخرى

% تعريف المسار
path_pts = [-20  20  20 -20 -20;
            -20 -20  20  20 -20;
              0   5  10   5   0];

% x0 : [X; Y; Z; theta]
x = [0; 0; 0; 0];

dt = 0.05;
v = 10;
T = 100;
current_target = 1;
scale = 3.0;
target_tolerance = 3.0;

% ========== PD للزاوية ==========
Kp_theta = 4;
Kd_theta = 1.5;

% ========== PID للارتفاع ==========
Kp_z = 1.2;
Ki_z = 0.4;
Kd_z = 0.3;

% متغيرات تكامل ومشتق
persistent prev_theta_error int_z prev_dz
prev_theta_error = 0;
int_z = 0;
prev_dz = 0;

figure;

for t = 0:dt:T
    clf; hold on; grid on; axis equal;
    axis([-30 30 -30 30 -5 15]);
    xlabel('X'); ylabel('Y'); zlabel('Z');
    view(3);

    plot3(path_pts(1,:), path_pts(2,:), path_pts(3,:), 'r-', 'LineWidth', 3);

    target = path_pts(:, current_target);

    if norm(x(1:3) - target) < target_tolerance
        current_target = current_target + 1;
        if current_target > size(path_pts, 2)
            title('وصلنا إلى نهاية المسار!');
            draw_car_scaled(x, 'b', scale);
            break;
        end
        target = path_pts(:, current_target);
    end

    % الأخطاء
    dx = target(1) - x(1);
    dy = target(2) - x(2);
    dz = target(3) - x(3);

    theta_desired = atan2(dy, dx);
    theta_error = atan2(sin(theta_desired - x(4)), cos(theta_desired - x(4)));

    % =================================================
    %              متحكم PD للزاوية
    % =================================================
    der_theta = (theta_error - prev_theta_error) / dt;
    omega = Kp_theta * theta_error + Kd_theta * der_theta;
    prev_theta_error = theta_error;

    % ساتوريشن
    omega = max(min(omega, 2), -2);

    % =================================================
    %              متحكم PID للارتفاع
    % =================================================
    int_z = int_z + dz * dt;
    der_z = (dz - prev_dz) / dt;

    vz = Kp_z * dz + Ki_z * int_z + Kd_z * der_z;

    prev_dz = dz;

    % ساتوريشن
    vz = max(min(vz, 5), -5);

    % ------------------------------------
    %      تكامل RK4 (بدون تغيير)
    % ------------------------------------
    u = [v; omega; vz];

    k1 = system_dynamics(x, u);
    k2 = system_dynamics(x + k1*(dt/2), u);
    k3 = system_dynamics(x + k2*(dt/2), u);
    k4 = system_dynamics(x + k3*dt, u);

    x = x + (dt/6) * (k1 + 2*k2 + 2*k3 + k4);
    x(4) = atan2(sin(x(4)), cos(x(4)));

    car(x, 'b', scale);

    drawnow;
end

disp('انتهت المحاكاة!');
end

% ----------------------------------------------
%       لا تغييرات في الديناميك أو الرسم
% ----------------------------------------------
function dxdt = system_dynamics(x, u)
    v = u(1);
    omega = u(2);
    vz = u(3);
    theta = x(4);

    dxdt = [v*cos(theta);
            v*sin(theta);
            vz;
            omega];
end
