close all;
load part1_results.mat;
% additional G5 is created with a slightly larger radius than G4
% to compare the performance of the networks in terms of rendezvous time as required. 
G5 = make_disk(P0, rmin+0.4);
WAs = {make_WA(G1), make_WA(G2), make_WA(G3), make_WA(G4), make_WA(G5)};
WBs = {make_WB(G1), make_WB(G2), make_WB(G3), make_WB(G4), make_WB(G5)};
n = size(P0,1);
Gs = {G1, G2, G3, G4, G5};
Wchecks(WAs, WBs, Gs);
% Where WAs and WBs are the weight matrices for the five network topologies, 
% and G1, G2, G3, G4, G5 are the corresponding adjacency matrices. 
% The function Wchecks verifies that the weight matrices satisfy certain properties,
% such as row sums equal to 1 and non-negativity.

%Experiment E1: Assess the performance of networks 1-5 for fastest rendevous.
% (Bradley and Alex please expand on this I don't fully understand the topologies)
%The initial positions of the robots are given by P0, and the weight matrices for each network topology are given by WAs and WBs.
% Predict broadcast protocal WA1 and WB1 will be the fastest because all the robots will be able to communicate with each other directly, 
% allowing for faster convergence to a common position.
% I predict that star will also be quite fast becaus the most robots will quickly converge to the center of the star, as they can all communicate with the center robot. 
% The ring topology will be slower because the robots can only communicate with their immediate neighbors, which will slow down the convergence process. 
% The disk topology will also be slower because the robots can only communicate with other robots within a certain distance,
% which may limit the number of robots that can communicate with each other at any given time, 
% especially if there are outlying robots that are far from others. 

% Setting rendezvous condition to be 1% of the spread of the initial positions of the robots,
% as instructed by the handout.
rendezvous_condition = 0.01*Spread(P0(:,1),P0(:,2));
rendevous_times = zeros(5,2);
for i = 1:5
    % Looping through each of the topologies
    K=7000;
    %Set the initial number of time steps to simulate to 100.
    break_flag = false;
    % break_flag is used later to exit the while loop
    % while (K < 5000)
    %     % iterate up to 5000 time steps, if rendezvous condition is not met, 
    %     % increase K by 100 and repeat the simulation.
    %     % 5000 doesn't actually let the smaller disk network (G4) converge, but I had to avoid excessive computation time.
    %     % increase above if you want to see G4 converge
    %     WA = WAs{i};
    %     WB = WBs{i};
    %     X0 = P0(:,1);
    %     Y0 = P0(:,2);
    %     X_A = simulate_linear(WA, X0, K);
    %     Y_A = simulate_linear(WA, Y0, K);
    %     X_B = simulate_linear(WB, X0, K);
    %     Y_B = simulate_linear(WB, Y0, K);
    %     spread_A = zeros(K+1,1);
    %     %Creating empty arrays to store the spread values for each time step
    %     spread_B = zeros(K+1,1);
    %     for k = 1:K+1
    %         spread_A(k) = Spread(X_A(:,k),Y_A(:,k));
    %         %Calling the spread function (delta_k in the hand out) to compute the spread of robots
    %         spread_B(k) = Spread(X_B(:,k),Y_B(:,k));
    %         if spread_A(k) < rendezvous_condition && spread_B(k) < rendezvous_condition
    %             break_flag = true;
    %             %While loop will break if both networks meet the rendezvous condition at the same time step k.
    %         end
    %         if spread_A(k) < rendezvous_condition && rendevous_times(i,1) == 0
    %             rendevous_times(i,1) = k;
    %             %update the rendezvous time for network A if it meets the condition and has not been recorded yet.
    %         end
    %         if spread_B(k) < rendezvous_condition && rendevous_times(i,2) == 0
    %             rendevous_times(i,2) = k;
    %             %update the rendezvous time for network B if it meets the condition and has not been recorded yet.
    %         end
    %     end
    %     if break_flag
    %         break;
    %         %exit the loop
    %     else
    %         K = K + 100;
    %         %or increase K by 100 and repeat the simulation.
    %     end
    % end

    WA = WAs{i};
    WB = WBs{i};
    X0 = P0(:,1);
    Y0 = P0(:,2);
    X_A = simulate_linear(WA, X0, K);
    Y_A = simulate_linear(WA, Y0, K);
    X_B = simulate_linear(WB, X0, K);
    Y_B = simulate_linear(WB, Y0, K);


    for k = 1:K+1
        spread_A(k) = Spread(X_A(:,k),Y_A(:,k));
        %Calling the spread function (delta_k in the hand out) to compute the spread of robots
        spread_B(k) = Spread(X_B(:,k),Y_B(:,k));
        if spread_A(k) < rendezvous_condition && spread_B(k) < rendezvous_condition
            break_flag = true;
            %While loop will break if both networks meet the rendezvous condition at the same time step k.
        end
        if spread_A(k) < rendezvous_condition && rendevous_times(i,1) == 0
            rendevous_times(i,1) = k;
            %update the rendezvous time for network A if it meets the condition and has not been recorded yet.
        end
        if spread_B(k) < rendezvous_condition && rendevous_times(i,2) == 0
            rendevous_times(i,2) = k;
            %update the rendezvous time for network B if it meets the condition and has not been recorded yet.
        end
    end
    
    figure;
    t = (0:length(spread_A)-1).';
    plot(t, spread_A, 'b-', 'LineWidth', 2); hold on;
    plot(t, spread_B, 'r--', 'LineWidth', 2); hold off;
    xlabel('Time step k'); ylabel('Spread');
    title(sprintf('Network %d: Spread over time, Rendezvous Time A: %d, Rendezvous Time B: %d', i, rendevous_times(i,1), rendevous_times(i,2)));
    legend('Weight Matrix A', 'Weight Matrix B');
    %Plotting, nothing to see here :)
end

function delta = Spread(x,y)
    % k is time step,
    % the function computes the spread between robots at time step k.
    % x and y are the x and y coordinates of the robots at time step k, respectively.
    n  = size(x, 1);
    C  = eye(n) - (1/n) * ones(n);
    CX = C * x;
    CY = C * y;
    delta = sqrt(sum(CX.^2, 1) + sum(CY.^2, 1));
end
function Wchecks(WAs, WBs, Gs)
    Bools= zeros(5,3);
    for i = 1:5
        WA = WAs{i};
        WB = WBs{i};
        n = size(WA,1);
        d= Gs{i} * ones(n,1);
        v=(eye(n)+diag(d)) * ones(n,1);
        Bools(i,2) = all(v' * WA - v' < 1e-10);
        Bools(i,1) = all(abs(WB * ones(n,1) - ones(n,1)) < 1e-10);
        Bools(i,3) = all(WB(:) >= 0);
    end
    if all(Bools(:))
        fprintf('All W checks passed\n');
    else
        fprintf('Some W checks failed:\n');
        disp(Bools);
    end

end
function W = make_WA(G)
    n = size(G,1);
    d = G * ones(n,1);
    D = diag(d);
    I = eye(n);
    W = (I + D) \ (I + G); 
end

function W = make_WB(G)
    n = size(G,1);
    d = G * ones(n,1);
    D = diag(d);
    L = D - G;                  % Laplacian
    epsilon = 1 / max(d);
    W = eye(n) - epsilon * L;
end

function G = make_disk(P, r)
    n = size(P, 1);
    s = P(:, 1).^2 + P(:, 2).^2;
    Delta = s * ones(1, n) + ones(n, 1) * s' - 2 * (P * P');
    G = (Delta < r^2) - eye(n);
end
