function X= simulate_anchored(W,lambda, anchor,x0, K)
    n  = length(x0);
    X  = zeros(n, K + 1);
    X(:, 1) = x0;
    for k = 1:K
        X(:, k + 1) = lambda * W * X(:, k) + (eye(n) - lambda)* anchor;
    end
end