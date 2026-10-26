load part1_results.mat;
WAs = {make_WA(G1), make_WA(G2), make_WA(G3), make_WA(G4)};
WBs = {make_WB(G1), make_WB(G2), make_WB(G3), make_WB(G4)};
Wchecks(WAs, WBs, {G1, G2, G3, G4});
function Wchecks(WAs, WBs, Gs)
    Bools= zeros(4,3);
    for i = 1:4
        WA = WAs{i};
        WB = WBs{i};
        n = size(WA,1);
        d= Gs{i} * ones(n,1);
        v=(eye(n)+diag(d)) * ones(n,1);
        Bools(i,2) = all(v' * WA - v' < 1e-10);
        Bools(i,1) = all(abs(WB * ones(n,1) - ones(n,1)) < 1e-10);
        Bools(i,3) =  all(WB(:) >= 0);
    end
    if all(Bools(:))
        fprintf('All W checks passed\n');
    else
        fprintf('Some W checks failed:\n');
        disp(Bools);
    end

end
function W = make_WA(G)
    n = size(G,1);
    d = G * ones(n,1);
    D = diag(d);
    I = eye(n);
    W = (I + D) \ (I + G); 
end

function W = make_WB(G)
    n = size(G,1);
    d = G * ones(n,1);
    D = diag(d);
    L = D - G;                  % Laplacian
    epsilon = 1 / max(d);
    W = eye(n) - epsilon * L;
end

