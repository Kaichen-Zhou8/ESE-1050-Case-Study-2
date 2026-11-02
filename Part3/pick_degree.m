function S = pick_degree(D, m)
    d = D.G * ones(size(D.G,1), 1);
    d(D.faulty) = -Inf;
    [~, i] = sort(d, 'descend');
    S = i(1:m);
end