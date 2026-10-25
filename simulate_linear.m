function X = simulate_linear(W, x0, K)
    x0 = x0(:);
    n  = length(x0);
    X  = zeros(n, K + 1);
    X(:, 1) = x0;
    for k = 1:K
        X(:, k + 1) = W * X(:, k);
    end
end