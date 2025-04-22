% Component values
R1 = 1;        % Ohms
R2 = 2;        % Ohms
R3 = 10;       % Ohms
R4 = 0.1;      % Ohms
RO = 1000;     % Ohms
C = 0.25;      % Farads
L = 0.2;       % Henrys
alpha = 100;   % Unitless

% Conductance matrix G
G = [ 1/R1 + 1i*0, -1/R1,           0,           0,           0,           0,           0;
     -1/R1,        1/R1 + 1/R2,    -1/R2,        0,           0,           0,           0;
      0,          -1/R2,           1/R2 + 1/R3,  0,          -1,           0,           0;
      0,           0,              0,           -1/R4,        1,          -alpha,       0;
      0,           0,              0,            0,           0,          -alpha,       1/RO;
      0,           0,              0,            1i*L,       -1,           0,           0;
      0,           0,              0,            0,           0,          -alpha,       1 ];

% Capacitance/Inductance matrix C
C_matrix = diag([C, 0, 0, 0, 0, L, 0]);

% Source vector F (will be defined in each analysis)
F = zeros(7, 1);
