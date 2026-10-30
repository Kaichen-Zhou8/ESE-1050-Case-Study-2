function J = score_mission(D, S, lamLead, T, m)
%SCORE_MISSION  Score J (percent reduction in mean squared distance to g)
%   J = score_mission(D, S) for deployment D (from make_deployment) and
%   leader set S. Defaults: leader lambda = 0.5, T = 125, budget m = 4.
%   Optional: score_mission(D, S, lamLead, T, m) to test other settings.
%   Dynamics: x[k+1] = Lam*W*x[k] + (I-Lam)*a, with W = W_A.

    if nargin < 3, lamLead = 0.5; end
    if nargin < 4, T = 125;       end
    if nargin < 5, m = 4;         end

    n = size(D.G, 1);
    S = S(:);

    % ---- validity checks on the leader set ----
    assert(numel(S) <= m,                 'S has more than m leaders');
    assert(numel(unique(S)) == numel(S),  'S contains repeated robots');
    assert(all(S >= 1 & S <= n & S == round(S)), 'S has invalid indices');
    assert(~any(ismember(S, D.faulty)),   'S contains a faulty robot');

    % ---- Protocol A weight matrix ----
    d = D.G * ones(n, 1);
    W = (eye(n) + diag(d)) \ (eye(n) + D.G);

    working = setdiff((1:n)', D.faulty(:));

    ebase = run_mission(W, D, [],  lamLead, T, working);   % no leaders
    enew  = run_mission(W, D, S,   lamLead, T, working);   % with leaders

    J = (100 / T) * sum(1 - enew ./ ebase);
end

function e = run_mission(W, D, S, lamLead, T, working)
    n = size(W, 1);
    lam = ones(n, 1);
    lam(D.faulty) = 0;              % faulty: broken drive
    a = D.P0;                       % anchors = landing positions
    if ~isempty(S)
        lam(S) = lamLead;           % leaders: partly follow protocol
        a(S, :) = repmat(D.g, numel(S), 1);   % ... partly head to g
    end

    X = D.P0;                       % columns are x and y
    e = zeros(T, 1);
    for k = 1:T
        X = lam .* (W * X) + (1 - lam) .* a;
        e(k) = mean(sum((X(working, :) - D.g).^2, 2));
    end
end