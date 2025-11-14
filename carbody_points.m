function draw_car_body_points_only(x)
% x = [X Y Z theta] : 
if length(x) < 4, x(4) = 0; end 
figure;
hold on; grid on; axis equal; view(3);
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Car Body Points');
body = [
    -1  1  1 -1 -1;       % X
    -0.5 -0.5 0.5 0.5 -0.5; % Y
     0   0  0  0  0       % Z
];
body_top = body + [0;0;0.5];
% Matrice de Rotation
theta = x(4);
R = [cos(theta) -sin(theta) 0;
     sin(theta)  cos(theta) 0;
     0           0          1];
body = R*body + x(1:3);
body_top = R*body_top + x(1:3);
%les point
scatter3(body(1,:), body(2,:), body(3,:), 100, 'b', 'filled');    
scatter3(body_top(1,:), body_top(2,:), body_top(3,:), 100, 'r', 'filled'); 
end