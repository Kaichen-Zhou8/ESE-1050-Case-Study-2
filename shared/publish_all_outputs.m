%% Part I: Communication Networks
close all;
run_in_own_workspace(fullfile(projectRoot,'Part1','part1_script.m'));
close all;
run_in_own_workspace(fullfile(projectRoot,'Part2','part2_script.m'));
close all;
run_in_own_workspace(fullfile(projectRoot,'Part3','part3_step1.m'));
close all;
run_in_own_workspace(fullfile(projectRoot,'Part3','part3_D1_script.m'));
close all;
run_in_own_workspace(fullfile(projectRoot,'Part3','function_testing.m'));
close all;
run_in_own_workspace(fullfile(projectRoot,'Part3','evaluate_mission.m'));
close all;

function run_in_own_workspace(f)
    run(f);
end