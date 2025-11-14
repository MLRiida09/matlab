function path_points()
% رسم نفس المسار الأول لكن نقاط فقط

% تعريف المسار
path = [-20  20  20 -20 -20;
        -20 -20  20  20 -20;
          0   5  10   5   0];

figure;
hold on; grid on; axis equal;
axis([-30 30 -30 30 -5 15]);
xlabel('X'); ylabel('Y'); zlabel('Z');
title('3D Path Points');
view(3);

% رسم النقاط فقط
scatter3(path(1,:), path(2,:), path(3,:), 100, 'r', 'filled');


