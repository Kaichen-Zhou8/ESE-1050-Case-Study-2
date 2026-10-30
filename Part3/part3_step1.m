clear; clc; close all;
run(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'setup_project.m'));

m = 4;
seeds = 1:30;
names = {'Random', 'Highest degree', 'Closest to g'};
scores = zeros(numel(seeds), 3);

rng(0);
for i = 1:numel(seeds)
    D = make_deployment(seeds(i));
    scores(i, 1) = score_mission(D, pick_random(D, m));
    scores(i, 2) = score_mission(D, pick_degree(D, m));
    scores(i, 3) = score_mission(D, pick_closest(D, m));
end

rowNames = arrayfun(@(s) sprintf('seed_%d', s), seeds, 'UniformOutput', false);
T = array2table(scores, 'VariableNames', {'Random', 'Degree', 'Closest'}, ...
                'RowNames', rowNames);
disp(T);

fprintf('\n%-16s %8s %8s %8s\n', 'Strategy', 'Mean', 'Median', 'Worst');
for j = 1:3
    fprintf('%-16s %8.2f %8.2f %8.2f\n', names{j}, ...
        mean(scores(:,j)), median(scores(:,j)), min(scores(:,j)));
end

figure; hold on;
for j = 1:3
    plot(j * ones(size(scores,1), 1) + 0.08 * randn(size(scores,1), 1), ...
         scores(:,j), 'o');
    plot([j-0.3 j+0.3], median(scores(:,j)) * [1 1], 'k-', 'LineWidth', 2);
end
hold off;
set(gca, 'XTick', 1:3, 'XTickLabel', names);
ylabel('Score J (%)'); grid on;
title(sprintf('Baseline score distributions over %d practice deployments', numel(seeds)));

pickers = {@pick_random, @pick_degree, @pick_closest};
for j = 1:3
    [worst, idx] = min(scores(:, j));
    D = make_deployment(seeds(idx));
    S = pickers{j}(D, m);
    fprintf('%s worst: seed %d, J = %.2f\n', names{j}, seeds(idx), worst);

    figure; hold on;
    plot(graph(D.G), 'XData', D.P0(:,1), 'YData', D.P0(:,2), ...
         'NodeColor', [0.5 0.5 0.5], 'EdgeColor', [0.85 0.85 0.95], 'MarkerSize', 3);
    plot(D.P0(D.faulty,1), D.P0(D.faulty,2), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
    plot(D.P0(S,1), D.P0(S,2), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
    plot(D.g(1), D.g(2), 'bp', 'MarkerSize', 14, 'MarkerFaceColor', 'b');
    axis equal; grid on; hold off;
    legend('network', 'faulty', 'leaders', 'rally point g');
    title(sprintf('%s: worst case (seed %d, J = %.1f)', names{j}, seeds(idx), worst));
end

function S = pick_random(D, m)
    w = setdiff((1:size(D.G,1))', D.faulty(:));
    S = w(randperm(numel(w), m));
end

function S = pick_degree(D, m)
    d = D.G * ones(size(D.G,1), 1);
    d(D.faulty) = -Inf;
    [~, i] = sort(d, 'descend');
    S = i(1:m);
end

function S = pick_closest(D, m)
    dist = sum((D.P0 - D.g).^2, 2);
    dist(D.faulty) = Inf;
    [~, i] = sort(dist, 'ascend');
    S = i(1:m);
end