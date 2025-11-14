function carClosedLine
function xdot = f(x, u_theta, u_z)
    V = 1; 
    theta = x(4);
    xdot = [V * cos(theta); 
            V * sin(theta); 
            u_z; 
            u_theta]; 
end
path = [-20  20  20 -20 -20;
        -20 -20  20  20 -20;
          0   5  10   5   0];