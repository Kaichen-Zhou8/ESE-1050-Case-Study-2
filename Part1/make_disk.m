function G = make_disk(P, r)
    n = size(P, 1);
    s = P(:, 1).^2 + P(:, 2).^2;
    Delta = s * ones(1, n) + ones(n, 1) * s' - 2 * (P * P');
    G = (Delta < r^2) - eye(n);
end 