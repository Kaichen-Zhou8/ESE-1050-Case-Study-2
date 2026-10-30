function W = make_WA(G)
    n = size(G,1);
    d = G * ones(n,1);
    D = diag(d);
    I = eye(n);
    W = (I + D) \ (I + G); 
end