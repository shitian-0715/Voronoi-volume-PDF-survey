clc; clear;

guard_ratio = 0.6;
num_realizations = 4000;
valid_areas = [];
valid_volumes = [];

% ===================== 获取面积 =====================
% A_xmin = 0;
% A_xmax = 200;
% A_ymin = 0;
% A_ymax = 200;
% 
% for k = 1:num_realizations
%     areas_k = areas(A_xmin,A_xmax,A_ymin,A_ymax, guard_ratio);
%     valid_areas = [valid_areas; areas_k];
% end

% ===================== 获取体积 =====================

A_xmin = 0;
A_xmax = 20;
A_ymin = 0;
A_ymax = 20;
A_zmin = 0; 
A_zmax = 20;

for k = 1:num_realizations
    volumes_k = volumes(A_xmin, A_xmax, A_ymin, A_ymax, A_zmin, A_zmax, guard_ratio);
    valid_volumes = [valid_volumes; volumes_k];
end