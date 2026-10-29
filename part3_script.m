load part2_results.mat;
load part1_results.mat;

n = size(P0, 1);
x0 = P0(:, 1);
y0 = P0(:, 2);
K = 7000;
I = eye(n);

lambda = ones(n, 1);
leader = 1;
faulty = 2;
lambda(leader) = 0.5;
lambda(faulty) = 0;
lambda = diag(lambda);

% g is the rally point
g = [1, 1];
W = WAs{1};

a = x0;
b = y0;
a(leader) = g(1);
b(leader) = g(2);

X = simulate_anchored(W, lambda, a, x0, K);
Y = simulate_anchored(W, lambda, b, y0, K);

% solution : (I - lambda W)x* = (I - lambda)a
xstar = (I - lambda * W) \ ((I - lambda) * a);
ystar = (I - lambda * W) \ ((I - lambda) * b);

% remove semicolon to see that indeed the final state is a steady state
norm([xstar, ystar] - [X(:, 7001), Y(:, 7001)]);

% here is the practice deployment with no leaders
% lambda = I so each robot goes to the average of its neighbors, 
% and ignores the anchor. They all end up at the same point.
% a = x0;
% b = y0;
% lambda(leader) = 1;
% X2 = simulate_anchored(W, lambda, a, x0, K);
% Y2 = simulate_anchored(W, lambda, b, y0, K);