function delta = Spread(x,y)
    % x and y are the x and y coordinates
    n  = size(x, 1);
    C  = eye(n) - (1/n) * ones(n);
    CX = C * x;
    CY = C * y;
    delta = sqrt(sum(CX.^2, 1) + sum(CY.^2, 1));
end