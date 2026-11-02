function Wchecks(WAs, WBs, Gs)
    Bools= zeros(5,3);
    for i = 1:size(WAs,2)
        WA = WAs{i};
        WB = WBs{i};
        n = size(WA,1);
        d= Gs{i} * ones(n,1);
        v=(eye(n)+diag(d)) * ones(n,1);
        Bools(i,2) = all(abs(v' * WA - v')< 1e-10);
        Bools(i,1) = all(abs(WB * ones(n,1) - ones(n,1)) < 1e-10);
        Bools(i,3) = all(WB(:) >= 0);
    end
    if all(Bools(:))
        fprintf('All W checks passed\n');
    else
        fprintf('Some W checks failed:\n');
        disp(Bools);
    end

end