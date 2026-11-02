function S = pick_closest(D, m)
    dist = sum((D.P0 - D.g).^2, 2);
    dist(D.faulty) = Inf;
    [~, i] = sort(dist, 'ascend');
    S = i(1:m);
end