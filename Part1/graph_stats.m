function stats = graph_stats(G)
    n   = size(G, 1);
    one = ones(n, 1);

    stats.degree = G * one;                 
    stats.edges  = 0.5 * (one' * G * one);  

    A = eye(n) + G;
    R = double(A > 0);                    
    k = 1;
    while any(R(:) == 0) && k < n
        R = double((A * R) > 0);            
        k = k + 1;
    end

    if any(R(:) == 0)
        stats.diameter = Inf;
    else
        stats.diameter = k;
    end
