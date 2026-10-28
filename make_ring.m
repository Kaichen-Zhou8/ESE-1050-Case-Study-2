function G = make_ring(n, k)
    G = zeros(n);
    S = eye(n);
    S = S(:, [2:end, 1]);
    for i = 1:k
        G = G + S^i + (S^i)';
    end
end