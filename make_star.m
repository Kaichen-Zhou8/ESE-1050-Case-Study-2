function G = make_star(n)
    e1 = eye(n);
    e1 = e1(:, 1);
    G = zeros(n);
    G = e1 * ones(1, n) + ones(n, 1) * e1' -  2 * e1 * e1';
end