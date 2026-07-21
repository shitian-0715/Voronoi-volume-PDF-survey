%% ===================== 模型名称 =====================

model_names = { ...
    'Hinde and Miles (2D)', ...
    'Tanemura (2D)', ...
    'Weaire et al (2D)', ...
    'DiCenzo (2D)', ...
    'Ferenc and Neda (2D)', ...
    'Proposed (TG) (2D)', ...
    'Proposed (GG) (2D)', ...
    'Tanemura (3D)', ...
    'Kiang (3D)', ...
    'Ferenc and Neda (3D)', ...
    'Proposed (TG) (3D)', ...
    'Proposed (GG) (3D)'};

analytical_xs = {x1, x2, x3, x4, x5, x1_2d, x2_2d, ...
                 x6, x7, x8, x_3d, x2_3d};

analytical_ys = {y1, y2, y3, y4, y5, y1_2d, y2_2d, ...
                 y6, y7, y8, y_3d, y2_3d};

num_models = length(model_names);

MSE_all = zeros(num_models,1);
MAE_all = zeros(num_models,1);
R2_all  = zeros(num_models,1);

%% ===================== 计算误差 =====================

for i = 1:num_models

    analytical_x = analytical_xs{i};
    analytical_y = analytical_ys{i};

    if i <= 7
        empirical_x = bin_centers1;
        empirical_y = counts1;
    else
        empirical_x = bin_centers2;
        empirical_y = counts2;
    end

    y_interp = interp1(empirical_x, empirical_y, ...
                       analytical_x, 'linear', 'extrap');

    MSE_all(i) = mean((y_interp - analytical_y).^2);
    MAE_all(i) = mean(abs(y_interp - analytical_y));
    SSE = sum((y_interp - analytical_y).^2);
    SST = sum((analytical_y - mean(analytical_y)).^2);
    R2_all(i)  = 1 - (SSE / SST);
end

%% ===================== 分组排序 =====================

% -------- 2D --------
idx_2d = 1:7;
[MSE_2d_sorted, sort_2d] = sort(MSE_all(idx_2d));
sort_2d = idx_2d(sort_2d);

% -------- 3D --------
idx_3d = 8:12;
[MSE_3d_sorted, sort_3d] = sort(MSE_all(idx_3d));
sort_3d = idx_3d(sort_3d);

%% ===================== 打印结果 =====================

fprintf('\n=============================================================\n');
fprintf('                     2D Model Ranking\n');
fprintf('=============================================================\n');
fprintf('%-3s %-22s %-12s %-12s %-12s\n', ...
        '#', 'Model', 'MSE', 'MAE', 'R^2');
fprintf('-------------------------------------------------------------\n');

for k = 1:length(sort_2d)
    i = sort_2d(k);
    fprintf('%-3d %-22s %-12.4e %-12.4e %-12.6f\n', ...
            k, model_names{i}, ...
            MSE_all(i), MAE_all(i), R2_all(i));
end

fprintf('\n=============================================================\n');
fprintf('                     3D Model Ranking\n');
fprintf('=============================================================\n');
fprintf('%-3s %-22s %-12s %-12s %-12s\n', ...
        '#', 'Model', 'MSE', 'MAE', 'R^2');
fprintf('-------------------------------------------------------------\n');

for k = 1:length(sort_3d)
    i = sort_3d(k);
    fprintf('%-3d %-22s %-12.4e %-12.4e %-12.6f\n', ...
            k, model_names{i}, ...
            MSE_all(i), MAE_all(i), R2_all(i));
end

fprintf('=============================================================\n\n');