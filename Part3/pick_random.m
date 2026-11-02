function S = pick_random(D, m)
    w = setdiff((1:size(D.G,1))', D.faulty(:));
    S = w(randperm(numel(w), m));
end