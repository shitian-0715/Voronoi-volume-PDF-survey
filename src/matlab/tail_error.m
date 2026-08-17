%% ============================================================
%                Tail Comparison (Robust Version)
% =============================================================

clear rmse beta_model beta_emp

%% ===================== 全局字体设为 Times New Roman =====================
set(groot,'defaultAxesFontName','Times New Roman');
set(groot,'defaultTextFontName','Times New Roman');
set(groot,'defaultLegendFontName','Times New Roman');

%% ===================== 样式表（与主图一致） =====================
styles = containers.Map('KeyType','char','ValueType','any');

styles('Hinde and Miles') = struct('LineStyle','-',  'Marker','none', 'Color',[0.00 0.45 0.74]);
styles('Tanemura')        = struct('LineStyle','--', 'Marker','none', 'Color',[0.47 0.67 0.19]);
styles('Weaire et al')          = struct('LineStyle',':',  'Marker','none', 'Color',[0.93 0.69 0.13]);
styles('DiCenzo and Wertheim')         = struct('LineStyle','-.', 'Marker','none', 'Color',[0.49 0.18 0.56]);
styles('Ferenc and Neda')          = struct('LineStyle','--', 'Marker','none', 'Color',[0.85 0.33 0.10]);
styles('Proposed (TG)') = struct('LineStyle','-',  'Marker','none', 'Color',[0.30 0.75 0.93]);
styles('Proposed (GG)') = struct('LineStyle',':',  'Marker','none', 'Color',[1 0 0]);
styles('Kiang')           = struct('LineStyle','-.', 'Marker','none', 'Color',[0.00 0.00 0.00]);

plotStyled = @(x,y,label,lw) plot(x, y, ...
    'LineStyle', styles(label).LineStyle, ...
    'Color',     styles(label).Color, ...
    'LineWidth', lw, ...
    'DisplayName', label);

%% ============================================================
%                       2D Tail
% =============================================================

%% 1️⃣ 设定尾部区间
tail_min = 3.3;
tail_max = 3.9;

tail_idx = (bin_centers1 > tail_min & bin_centers1 < tail_max);

y_tail   = bin_centers1(tail_idx);
emp_tail = counts1(tail_idx);

valid = emp_tail > 0 & ~isnan(emp_tail) & ~isinf(emp_tail);
y_tail   = y_tail(valid);
emp_tail = emp_tail(valid);

log_emp = log(emp_tail);

%% 2️⃣ 模型
model_names = { ...
    'Hinde and Miles', ...
    'Tanemura', ...
    'Weaire et al', ...
    'DiCenzo and Wertheim', ...
    'Ferenc and Neda', ...
    'Proposed (TG)', ...
    'Proposed (GG)'};

x_models = {x1, x2, x3, x4, x5, x1_2d, x2_2d};
y_models = {y1, y2, y3, y4, y5, y1_2d, y2_2d};

num_models = length(model_names);

rmse = zeros(num_models,1);
beta_model = zeros(num_models,1);

%% 3️⃣ 经验尾指数
p_emp = polyfit(y_tail, log_emp, 1);
beta_emp = -p_emp(1);

%% 4️⃣ 逐模型计算
for k = 1:num_models
    
    f_model = interp1(x_models{k}, y_models{k}, y_tail, 'linear');
    
    valid_model = f_model > 0 & ~isnan(f_model) & ~isinf(f_model);
    
    y_valid = y_tail(valid_model);
    log_emp_valid = log_emp(valid_model);
    log_model = log(f_model(valid_model));
    
    w = exp(log_emp_valid);
    w = w / sum(w);
    
    rmse(k) = sqrt( sum(w .* (log_emp_valid - log_model).^2) );
    
    p_model = polyfit(y_valid, log_model, 1);
    beta_model(k) = -p_model(1);
end

%% 5️⃣ 排序输出
[rmse_sorted, idx_sort] = sort(rmse);

fprintf('\n====================================================\n')
fprintf('        2D Tail Weighted log-RMSE Ranking\n')
fprintf('====================================================\n\n')

for i = 1:num_models
    idx = idx_sort(i);
    fprintf('%d. %-20s  RMSE = %.6e   |  beta = %.6f\n', ...
        i, model_names{idx}, rmse(idx), beta_model(idx));
end

fprintf('\nEmpirical beta = %.6f\n\n', beta_emp);

%% 6️⃣ 平滑误差图（样式统一）

window = 15;

figure; hold on; grid on;

for k = 1:num_models
    
    f_model = interp1(x_models{k}, y_models{k}, y_tail, 'linear');
    valid_model = f_model > 0;
    
    err = log(f_model(valid_model)) - log_emp(valid_model);
    y_plot = y_tail(valid_model);
    
    err_smooth = movmean(err, window);
    
    h(k) = plotStyled(y_plot, err_smooth, model_names{k}, 1.5);
end

yline(0,'k--','LineWidth',1.5);
xlabel('$v$','Interpreter','latex');
ylabel('Smoothed log Error');
% title('2D Smoothed Tail Log Error');

order2d = [5 4 6 3 1 7 2];
legend(h(order2d), model_names(order2d), 'Location','best');


%% ============================================================
%                       3D Tail
% =============================================================

clear rmse3 beta_model3 beta_emp3

%% 1️⃣ 尾部区间
tail_min = 3.0;
tail_max = 3.6;

tail_idx = (bin_centers2 > tail_min & bin_centers2 < tail_max);

y_tail   = bin_centers2(tail_idx);
emp_tail = counts2(tail_idx);

valid = emp_tail > 0 & ~isnan(emp_tail) & ~isinf(emp_tail);
y_tail   = y_tail(valid);
emp_tail = emp_tail(valid);

log_emp = log(emp_tail);

%% 2️⃣ 模型
model_names3 = { ...
    'Tanemura', ...
    'Kiang', ...
    'Ferenc and Neda', ...
    'Proposed (TG)', ...
    'Proposed (GG)'};

x_models3 = {x6, x7, x8, x_3d, x2_3d};
y_models3 = {y6, y7, y8, y_3d, y2_3d};

num_models3 = length(model_names3);

rmse3 = zeros(num_models3,1);
beta_model3 = zeros(num_models3,1);

%% 3️⃣ 经验指数
p_emp = polyfit(y_tail, log_emp, 1);
beta_emp3 = -p_emp(1);

%% 4️⃣ 逐模型
for k = 1:num_models3
    
    f_model = interp1(x_models3{k}, y_models3{k}, y_tail, 'linear');
    
    valid_model = f_model > 0 & ~isnan(f_model) & ~isinf(f_model);
    
    y_valid = y_tail(valid_model);
    log_emp_valid = log_emp(valid_model);
    log_model = log(f_model(valid_model));
    
    w = exp(log_emp_valid);
    w = w / sum(w);
    
    rmse3(k) = sqrt( sum(w .* (log_emp_valid - log_model).^2) );
    
    p_model = polyfit(y_valid, log_model, 1);
    beta_model3(k) = -p_model(1);
end

%% 5️⃣ 排序
[rmse_sorted3, idx_sort3] = sort(rmse3);

fprintf('\n====================================================\n')
fprintf('        3D Tail Weighted log-RMSE Ranking\n')
fprintf('====================================================\n\n')

for i = 1:num_models3
    idx = idx_sort3(i);
    fprintf('%d. %-25s  RMSE = %.6e   |  beta = %.6f\n', ...
        i, model_names3{idx}, rmse3(idx), beta_model3(idx));
end

fprintf('\nEmpirical beta (3D) = %.6f\n\n', beta_emp3);

%% 6️⃣ 平滑误差图（统一样式）

window = 15;

figure; hold on; grid on;

for k = 1:num_models3
    
    f_model = interp1(x_models3{k}, y_models3{k}, y_tail, 'linear');
    valid_model = f_model > 0;
    
    err = log(f_model(valid_model)) - log_emp(valid_model);
    y_plot = y_tail(valid_model);
    
    err_smooth = movmean(err, window);
    
    h3(k) = plotStyled(y_plot, err_smooth, model_names3{k}, 1.5);
end

yline(0,'k--','LineWidth',1.5);
xlabel('$v$','Interpreter','latex');
ylabel('Smoothed log Error');
% title('3D Smoothed Tail Log Error');

order3d = [3 4 5 1 2];
legend(h3(order3d), model_names3(order3d), 'Location','best');