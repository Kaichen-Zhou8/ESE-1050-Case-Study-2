clear; clc; close all;

s = graph_stats(make_star(5))
s = graph_stats(make_ring(5,1))
s = graph_stats(make_complete(5))
s = graph_stats(blkdiag(make_complete(3), make_complete(3)))

W = [1 1; 0 1];
x0 = [0; 1];
K = 3;
X = simulate_linear(W, x0, K)
disp(norm(X(:,end) - W^K * x0))

n = 100;
rng(105); P0 = [5*rand(50,2); 5*rand(50,2) + [6 0]];

rmin = NaN;
for j = 1:200
    r = j/10;
    if isfinite(graph_stats(make_disk(P0, r)).diameter)
        rmin = r;
        break
    end
end
fprintf('r_min = %.1f\n', rmin);

G4 = make_disk(P0, rmin);
s4 = graph_stats(G4);

kmax = floor((n-1)/2);
ringEdges = zeros(kmax,1);
for k = 1:kmax
    ringEdges(k) = graph_stats(make_ring(n,k)).edges;
end
[~, kbest] = min(abs(ringEdges - s4.edges));
fprintf('T4 edges = %d, ring k = %d (ring edges = %d)\n', ...
        s4.edges, kbest, ringEdges(kbest));

Gs = {make_complete(n), make_star(n), make_ring(n,kbest), G4};
names = {'T1 Complete'; 'T2 Star'; 'T3 Ring'; 'T4 Disk'};

Edges = zeros(4,1); MeanDeg = zeros(4,1); MaxDeg = zeros(4,1); Diam = zeros(4,1);
for i = 1:4
    st = graph_stats(Gs{i});
    Edges(i)   = st.edges;
    MeanDeg(i) = mean(st.degree);
    MaxDeg(i)  = max(st.degree);
    Diam(i)    = st.diameter;
end
T = table(Edges, MeanDeg, MaxDeg, Diam, 'RowNames', names);
disp(T);

figure;
plot(graph(G4), 'XData', P0(:,1), 'YData', P0(:,2), ...
     'NodeColor', 'k', 'EdgeColor', [0.6 0.6 0.9], 'MarkerSize', 3);
axis equal; grid on; xlabel('x'); ylabel('y');
title(sprintf('T4 disk network, r = %.1f', rmin));

G1 = Gs{1}; G2 = Gs{2}; G3 = Gs{3};
save('part1_results.mat', 'P0', 'rmin', 'kbest', 'G1', 'G2', 'G3', 'G4');

function G = make_complete(n)
    G = ones(n) - eye(n);
end

function G = make_star(n)
    e1 = eye(n);
    e1 = e1(:, 1);
    G = e1 * ones(1, n) + ones(n, 1) * e1' - 2 * e1 * e1';
end

function G = make_ring(n, k)
    G = zeros(n);
    S = eye(n);
    S = S(:, [2:end, 1]);
    for i = 1:k
        G = G + S^i + (S^i)';
    end
end

function G = make_disk(P, r)
    n = size(P, 1);
    s = P(:, 1).^2 + P(:, 2).^2;
    Delta = s * ones(1, n) + ones(n, 1) * s' - 2 * (P * P');
    G = (Delta < r^2) - eye(n);
end