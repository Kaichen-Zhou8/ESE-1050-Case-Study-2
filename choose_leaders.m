function S = choose_leaders(G, P0, faulty, g, m)
%CHOOSE_LEADERS  Choose which robots become leaders (ESE 105, Case Study II, Part III).
%
%   S = choose_leaders(G, P0, faulty, g, m)
%
%   Inputs
%     G       n-by-n adjacency matrix of the communication network
%     P0      n-by-2 landing positions; row i is robot i's (x, y)
%     faulty  vector of indices of robots with broken drives
%     g       1-by-2 rally point
%     m       maximum number of leaders
%
%   Output
%     S       vector of at most m distinct robot indices, none of them faulty
%
%   Rules (see Section D.4 of the handout)
%     - Use only the network's structure: anything you can compute from G,
%       P0, faulty and g with the tools from Part I (degrees, hop counts,
%       distances, products and powers of G, ...).
%     - Do NOT simulate the swarm, and do NOT call score_mission.
%     - Must run in under 2 seconds on one deployment.
%     - Do not change the function name or the order of the inputs.
%       Helper functions are allowed, but put them in this file, below
%       this function, so that this single file is all we need to run it.
%
%   Team: <team name>
%   Members: <names>
%
%   Strategy (2-3 sentences describing your rule, in words):
%   Each robot is weighted by its squared distance from g, with faulty
%   robots weighted 0. Using the influence matrix built from powers of
%   W_A = (I+D)^-1 (I+G), we greedily pick the robot with the most
%   weighted influence over robots not yet covered, then discount the
%   robots it influences so later leaders spread to other parts of the
%   network (other zones).

n = size(G, 1);
d = G * ones(n, 1);
W = (eye(n) + diag(d)) \ (eye(n) + G);

hops  = 3;
alpha = 0.5;
M  = zeros(n);
Wk = eye(n);
for h = 1:hops
    Wk = Wk * W;
    M  = M + Wk;
end
M = M / hops;

w = sum((P0 - repmat(g, n, 1)).^2, 2);   % squared distance to g
w(faulty) = 0;

u = ones(n, 1);
blocked = false(n, 1);
blocked(faulty) = true;

m = min(m, sum(~blocked));
S = zeros(m, 1);
for t = 1:m
    b = M' * (w .* u);
    b(blocked) = -Inf;
    [~, l] = max(b);
    S(t) = l;
    blocked(l) = true;
    u = u .* (1 - min(1, alpha * M(:, l) / max(M(:, l))));
end

end