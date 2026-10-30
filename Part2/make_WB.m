function W = make_WB(G)
    n = size(G,1);
    d = G * ones(n,1);
    D = diag(d);
    L = D - G;                  % Laplacian
    epsilon = 1 / max(d);
    W = eye(n) - epsilon * L;
end