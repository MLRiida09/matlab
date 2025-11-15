function path()

path = [-21  20  20 -20 -21;
        -21 -20  20  20 -21;
          0  5  10   5   0];  

figure;
hold on; grid on; axis equal;
axis([-30 30 -30 30 -5 15]);
title('3DPath');
view(3);  

% رسم المسار
plot3(path(1,:), path(2,:), path(3,:), 'r-', 'LineWidth', 5);

end
