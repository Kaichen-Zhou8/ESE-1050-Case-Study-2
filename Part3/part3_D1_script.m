run(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'setup_project.m'));
load(fullfile(projectRoot, 'Part2', 'part2_results.mat'));
D = make_deployment(100);
n = size(D.P0, 1);
x0 = D.P0(:, 1);
y0 = D.P0(:, 2);
I = eye(n);
K = 10000;
lambda = ones(n, 1);

% this is a placeholder we may want to call choose leaders here
leader = 1;

lambda(leader) = 0.5;
lambda(D.faulty) = 0;
lambda = diag(lambda);
W = make_WA(D.G);

a = x0;
b = y0;
a(leader) = D.g(1);
b(leader) = D.g(2);

X = simulate_anchored(W, lambda, a, x0, K);
Y = simulate_anchored(W, lambda, b, y0, K);

% solution : (I - lambda W)x* = (I - lambda)a
xstar = (I - lambda * W) \ ((I - lambda) * a);
ystar = (I - lambda * W) \ ((I - lambda) * b);

% remove comment to see that indeed the final state is a steady state (final position = (x*, y*))
% this norm keeps decreasing as K increases.
% norm([xstar, ystar] - [X(:, K+1), Y(:, K+1)])

% here is the practice deployment with no leaders
% lambda = I so each robot goes to the average of its neighbors, and ignores the anchor. 
% It settles into a steady state, but  they aren't all at one point because of the faulty robots.
lambda = ones(n, 1);
lambda(D.faulty) = 0;
lambda = diag(lambda);
X = simulate_anchored(W, lambda, a, x0, K);
Y = simulate_anchored(W, lambda, b, y0, K);
% this norm is small which means they stop moving (steady state)
norm([X(:, K), Y(:, K)] - [X(:, K+1), Y(:, K+1)])