clear; clc; close all;
run(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'setup_project.m'));
D_test=make_deployment(1);
P0=D_test.P0(1:5,:)
complete=make_complete(5)
star=make_star(5)
ring=make_ring(5,1)
for j = 1:200
    r = j/10;
    if isfinite(graph_stats(make_disk(P0, r)).diameter)
        rmin = r;
        break
    end
end
fprintf('r_min = %.1f\n', rmin);
disk=make_disk(P0,rmin)
disk_big=make_disk(P0,rmin+0.4)
Gs_test={complete,star,ring,disk,disk_big};

WAs_test={make_WA(Gs_test{1}),make_WA(Gs_test{2}),make_WA(Gs_test{3}),make_WA(Gs_test{4}),make_WA(Gs_test{5})};
WBs_test={make_WB(Gs_test{1}),make_WB(Gs_test{2}),make_WB(Gs_test{3}),make_WB(Gs_test{4}),make_WB(Gs_test{5})};
for i=1:5
    fprintf('Network %d:\n', i);
    disp("Weight Matrix for Network A:")
    disp(WAs_test{i})
    disp("Weight Matrix for Network B:")
    disp(WBs_test{i})
end

for i=1:5
    fprintf('graph_stats, Network %d:\n', i);
    st=graph_stats(Gs_test{i})
end
st_disc=graph_stats(blkdiag(make_complete(3), make_complete(3)))

for i=1:5
    fprintf('Row sums, Network %d (WA, WB):\n', i);
    disp([WAs_test{i}*ones(5,1), WBs_test{i}*ones(5,1)])
end


x0=P0(:,1);
y0=P0(:,2);
K=30;
for i=1:5
    fprintf('Network %d, Protocol A:\n', i);
    XA=simulate_linear(WAs_test{i}, x0, K);
    disp(XA(:, [1:6, end]))
    fprintf('Network %d, Protocol B:\n', i);
    XB=simulate_linear(WBs_test{i}, x0, K);
    disp(XB(:, [1:6, end]))
end
mean(x0)
dd=Gs_test{4}*ones(5,1);
v=(eye(5)+diag(dd))*ones(5,1);
(v'*x0)/(v'*ones(5,1))
YA=simulate_linear(WAs_test{5}, y0, K);
disp("Spreads at each time step should decrease:")
for i=1:6
    disp(Spread(XA(:,i),YA(:,i)));
end
K=50;
XA=simulate_linear(WAs_test{5}, x0, K);
YA=simulate_linear(WAs_test{5}, y0, K);
disp("Spreads at final time step should be near zero:")
for i=1:5
    disp(Spread(XA(:,end-6+i),YA(:,end-6+i)));
end

g_test=D_test.g
lam=[1; 1; 0; 1; 0.5];
Lam=diag(lam);
ax=x0;
ay=y0;
ax(5)=g_test(1);
ay(5)=g_test(2);
WA=WAs_test{4};
Xa=simulate_anchored(WA, Lam, ax, x0, 6)
Ya=simulate_anchored(WA, Lam, ay, y0, 6)




