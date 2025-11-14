function follow_closed_path3D()
% مسار مغلق 3D: X, Y, Z
path = [-20  20  20 -20 -20;
        -20 -20  20  20 -20;
          0   5  10   5   0];  % ارتفاع مختلف لكل نقطة

% موضع المركبة الابتدائي [X;Y;Z;theta]
x = path(:,1);
x = [x(1:3); 0];  % [X;Y;Z;theta]
dt = 0.1;   % خطوة زمنية
v = 2;      % سرعة أمامية
T = 100;    % وقت المحاكاة الكلي

current_seg = 1; % القطعة الحالية

figure;
for t = 0:dt:T
    clf; hold on; grid on; axis equal;
    axis([-30 30 -30 30 -5 15]);
    view(3);

    % رسم المسار بالكامل
    plot3(path(1,:), path(2,:), path(3,:), 'r', 'LineWidth', 2);

    % نقاط القطعة الحالية
    a = path(:, current_seg);
    b = path(:, current_seg + 1);

    % اتجاه الخط في XY
    phi = atan2(b(2)-a(2), b(1)-a(1));

    % موقع المركبة XY
    m = x(1:2);

    % الانحراف الموقّع
    e = det([b(1:2)-a(1:2), m - a(1:2)]) / norm(b(1:2)-a(1:2));

    % زاوية التوجيه المطلوبة
    thetabar = phi - atan(e);

    % قانون التحكم
    u = atan(tan((thetabar - x(4))/2));

    % تحديث Z حسب التقدم على القطعة
    ab_vec = b - a;
    am_vec = x(1:3) - a;
    proj = dot(am_vec, ab_vec)/dot(ab_vec, ab_vec);
    proj = max(0, min(1, proj));
    z_target = a(3) + proj*(b(3)-a(3));
    vz = (z_target - x(3))*5;  % تصحيح سريع للارتفاع

    % تحديث موقع المركبة
    x = x + [v*cos(x(4)); v*sin(x(4)); vz; u]*dt;

    % رسم المركبة
    car(x, 'b');

    % التحقق من الوصول لنهاية القطعة
    if dot(b(1:2) - a(1:2), b(1:2) - m) < 0
        current_seg = current_seg + 1;
        if current_seg >= size(path,2)
            current_seg = 1; % العودة إلى البداية لإكمال الدورة
        end
    end

    drawnow;
end
end

% دالة رسم المركبة كمستطيل 3D بسيط
function draw_vehicle3D_simple(x, size, color)
if nargin<3, color='b'; end
if nargin<2, size=1; end

L = 2*size;
body = [ L/2 -L/2 -L/2  L/2 L/2;
          L/4  L/4 -L/4 -L/4 L/4;
          0    0    0    0   0];  % مستطيل صغير

% دوران حول Z
Rz = [cos(x(4)) -sin(x(4)) 0;
      sin(x(4))  cos(x(4)) 0;
      0          0         1];

body = Rz*body + x(1:3);

plot3(body(1,:), body(2,:), body(3,:), color, 'LineWidth', 2);
end

