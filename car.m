function draw_car3D_no_cabin(x, color)
% Fonction pour dessiner une voiture 3D simple sans cabine
% x = [X; Y; Z; theta]
% color = couleur de la voiture (par défaut 'r')

if nargin < 2, color = 'r'; end
if length(x) < 4, x(4) = 0; end  % زاوية الدوران

% إعداد الشكل
figure; hold on; grid on; axis equal; view(3);
xlabel('X'); ylabel('Y'); zlabel('Z');
title('3DCar ');

% أبعاد ثابتة
r = 0.3;  % نصف قطر العجلة

% جسم السيارة
body = [
    -1.0  1.0  1.0 -1.0 -1.0;
    -0.5 -0.5  0.5  0.5 -0.5;
     0.3  0.3  0.3  0.3  0.3
];
body_top = [
    -1.0  1.0  1.0 -1.0 -1.0;
    -0.5 -0.5  0.5  0.5 -0.5;
     0.8  0.8  0.8  0.8  0.8
];

% مصفوفة الدوران حول Z
R = [cos(x(4)) -sin(x(4)) 0;
     sin(x(4))  cos(x(4)) 0;
     0          0         1];

% تطبيق الدوران والإزاحة
body = R*body + x(1:3);
body_top = R*body_top + x(1:3);

% رسم الجسم
fill3(body(1,:), body(2,:), body(3,:), color, 'FaceAlpha', 0.9);
fill3(body_top(1,:), body_top(2,:), body_top(3,:), color, 'FaceAlpha', 0.9);
for i = 1:4
    j = mod(i,4)+1;
    side = [body(:,i) body(:,j) body_top(:,j) body_top(:,i)];
    fill3(side(1,:), side(2,:), side(3,:), color, 'FaceAlpha', 0.9);
end

% مواقع العجلات
pos = [0.8 -0.5; 0.8 0.5; -0.8 -0.5; -0.8 0.5];

% رسم العجلات
t = 0:pi/15:2*pi;  % الزاوية
w = 0.1;           % سمك العجلة
for i = 1:4
    circle = [pos(i,1)+0*t; r*cos(t); r*sin(t)];
    circle = R*circle + x(1:3);
    
    for side = [-w/2, w/2]
        offset = R*[0; side; 0];
        c_side = circle + offset;
        fill3(c_side(1,:), c_side(2,:), c_side(3,:), [0.1 0.1 0.1], 'EdgeColor', 'k');
    end
    
    n = length(t);
    for k = 1:4:n-1
        p1 = circle(:,k) + R*[0; -w/2; 0];
        p2 = circle(:,k) + R*[0; w/2; 0];
        p3 = circle(:,k+1) + R*[0; w/2; 0];
        p4 = circle(:,k+1) + R*[0; -w/2; 0];
        quad = [p1 p2 p3 p4];
        fill3(quad(1,:), quad(2,:), quad(3,:), [0.1 0.1 0.1]);
    end
end

end
