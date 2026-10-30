This repository contains the MATLAB files for ESE 1050 Case Study 2.

## Folder layout

- `Part1/` contains the Part 1 script and its generated `part1_results.mat`.
- `Part2/` contains the Part 2 script and its generated `part2_results.mat`.
- `Part3/` contains the Part 3 scripts and supporting Part 3 functions.
- `shared/` contains functions used by scripts across parts.
- `setup_project.m` adds the part and shared folders to the MATLAB path.

Run any part script from the MATLAB editor or command window. Each runnable
script calls `setup_project.m` automatically, so helper functions remain
available regardless of MATLAB's current folder. Part 1 and Part 2 result
files are loaded and saved using paths relative to the project folder.
