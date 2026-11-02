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
Gs_test={complete,star,ring,disk,make_disk(P0,rmin+0.4)};
WAs_test={make_WA(Gs_test{1}),make_WA(Gs_test{2}),make_WA(Gs_test{3}),make_WA(Gs_test{4}),make_WA(Gs_test{5})};
WBs_test={make_WB(Gs_test{1}),make_WB(Gs_test{2}),make_WB(Gs_test{3}),make_WB(Gs_test{4}),make_WB(Gs_test{5})};
for i=1:5
    fprintf('Network %d:\n', i);
    disp("Weight Matrix for Network A:")
    disp(WAs_test{1})
    disp("Weight Matrix for Network B:")
    disp(WBs_test{1})
end
Wchecks(WAs_test, WBs_test, Gs_test)






