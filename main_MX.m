clc; clear; close all;


%% ===================== 参数区 =====================
% 二维参数
a21 = 3.3095;  b21 = 3.0328;   c21 = 1.0787;
a22 = 3.315;   b22 = 3.04011;  c22 = 1.078;
a26 = 3.31605; b26 = 3.03689;  c26 = 1.07871;

a23 = 3.61;   b23 = 3.61;
a24 = 3.61;   b24 = 3.57;
a25 = 3.5692; b25 = 3.5692;
d2 = 2;

% 三维参数
a31 = 4.8065;  b31 = 4.06342;  c31 = 1.16391;
a32 = 6;       b32 = 6;
a33 = 5.5856;  b33 = 5.5856;
a34 = 4.828;   b34 = 4.097;    c34 = 1.160;
d3 = 3;

% 曲线数据
[x1, y1]       = P3(a21, b21, c21);           % Hinde and Miles (2D)
[x2, y2]       = P3(a22, b22, c22);           % Tanemura (2D)
[x3, y3]       = P2(a23, b23);                % Weaire et al (2D)
[x4, y4]       = P2(a24, b24);                % DiCenzo and Wertheim (2D)
[x5, y5]       = P1(d2);                      % Ferenc and Neda (2D)
[x1_2d, y1_2d] = P2(a25, b25);                % parm2 (2D)
[x2_2d, y2_2d] = P3(a26, b26, c26);           % parm3 (2D)

[x6, y6]       = P3(a31, b31, c31);           % Tanemura (3D)
[x7, y7]       = P2(a32, b32);                % Kiang (3D)
[x8, y8]       = P1(d3);                      % Ferenc and Neda (3D)
[x_3d, y_3d]   = P2(a33, b33);                % parm2 (3D)
[x2_3d, y2_3d] = P3(a34, b34, c34);           % parm3 (3D)

% 经验样本
% L = 20000;
% inner_ratio = 0.5;
% M = 1;
% valid_areas = area_fast(L, inner_ratio, M);

load('valid_areas.mat',   'valid_areas');

load('valid_volumes.mat', 'valid_volumes');

%% ===================== 全局绘图风格（IEEE） =====================
set(groot, 'defaultAxesFontName', 'Times New Roman');
set(groot, 'defaultTextFontName', 'Times New Roman');

lw  = 1.5;          % 线宽
msz = 10;           % 散点尺寸
fs_label  = 10;     % 轴标签字号
fs_legend = 6;      % 图例字号

% 单栏尺寸（IEEE 双栏文章的单栏宽度 ≈ 8.8 cm）
figW = 8.8;         % cm
figH = 7.5;         % cm（可调到 7.0–7.5）6.8

%% ===================== 样式表（Map，键可含空格） =====================
styles = containers.Map('KeyType','char','ValueType','any');
styles('Hinde and Miles') = struct('LineStyle','-',  'Marker','none', 'Color',[0.00 0.45 0.74]);
styles('Tanemura')        = struct('LineStyle','--', 'Marker','none', 'Color',[0.85 0.33 0.10]);
styles('Weaire et al')          = struct('LineStyle',':',  'Marker','none', 'Color',[0.93 0.69 0.13]);
styles('DiCenzo and Wertheim')         = struct('LineStyle','-.', 'Marker','none', 'Color',[0.49 0.18 0.56]);
styles('Ferenc and Neda')          = struct('LineStyle','--', 'Marker','none', 'Color',[0.47 0.67 0.19]);
styles('Proposed (TG)')           = struct('LineStyle','-',  'Marker','none', 'Color',[0.30 0.75 0.93]);
styles('Proposed (GG)')           = struct('LineStyle',':',  'Marker','none', 'Color',[1 0 0]);
styles('Kiang')           = struct('LineStyle','-.', 'Marker','none', 'Color',[0.00 0.00 0.00]);

plotStyled = @(ax,x,y,label,lw) plot(ax, x, y, ...
    'LineStyle', styles(label).LineStyle, ...
    'Color',     styles(label).Color, ...
    'Marker',    styles(label).Marker, ...
    'MarkerSize', 3, ...
    'LineWidth', lw, ...
    'DisplayName', label);

%% ===================== 图 (a)：2D 面积（独立文件） =====================
figA = figure('Units','centimeters','Position',[2 2 figW figH]);
set(figA,'PaperUnits','centimeters','PaperPosition',[0 0 figW figH]);

ax1 = axes('Parent',figA); hold(ax1,'on'); box(ax1,'on'); grid(ax1,'on');

[counts1, edges1] = histcounts(valid_areas, 400, 'Normalization','pdf');
bin_centers1 = (edges1(1:end-1) + edges1(2:end))/2;
scatter(ax1, bin_centers1, counts1, msz, ...
    'MarkerEdgeColor',[0 0 1], ...
    'LineWidth',0.8, ...
    'DisplayName','Empirical');

plotStyled(ax1, x3,     y3,     'Weaire et al',          lw);
plotStyled(ax1, x1_2d,  y1_2d,  'Proposed (TG)',           lw);
plotStyled(ax1, x5,     y5,     'Ferenc and Neda',          lw);
plotStyled(ax1, x4,     y4,     'DiCenzo and Wertheim',         lw);
plotStyled(ax1, x2,     y2,     'Tanemura',        lw);
plotStyled(ax1, x2_2d,  y2_2d,  'Proposed (GG)',           lw);
plotStyled(ax1, x1,     y1,     'Hinde and Miles', lw);


xlim(ax1,[0 5.5]);
ylim(ax1,[0 1.5]);
xlabel(ax1,'$v$','Interpreter','latex','FontSize',fs_label);
ylabel(ax1,'$f(v)$','Interpreter','latex','FontSize',fs_label);
set(ax1,'TickDir','in','LineWidth',1);
ax1.GridAlpha = 0.15;

lg1 = legend(ax1,'show','Location',[0.22 0.78 0.6 0.08],'FontSize',fs_legend,'NumColumns',2);
set(lg1,'Box','off');

% ====== 峰值局部图（2D） ====== 
pos1 = get(ax1,'Position');     % [left bottom width height]
w_in1 = 0.42 * pos1(3);
h_in1 = 0.3 * pos1(4);
x_in1 = pos1(1) + 0.50 * pos1(3);
y_in1 = pos1(2) + 0.40 * pos1(4);  
ax1_in = axes('Position',[x_in1, y_in1, w_in1, h_in1]);
hold(ax1_in,'on'); box(ax1_in,'on'); grid(ax1_in,'on');

scatter(ax1_in, bin_centers1, counts1, msz, ...
    'MarkerFaceColor','none', 'MarkerEdgeColor',[0 0 1]);
plotStyled(ax1_in, x1,     y1,     'Hinde and Miles', 1.0);
plotStyled(ax1_in, x2,     y2,     'Tanemura',        1.0);
plotStyled(ax1_in, x3,     y3,     'Weaire et al',          1.0);
plotStyled(ax1_in, x4,     y4,     'DiCenzo and Wertheim',         1.0);
plotStyled(ax1_in, x5,     y5,     'Ferenc and Neda',          1.0);
plotStyled(ax1_in, x1_2d,  y1_2d,  'Proposed (TG)',           1.0);
plotStyled(ax1_in, x2_2d,  y2_2d,  'Proposed (GG)',           1.0);

xlim(ax1_in,[0.55 0.9]);
ylim(ax1_in,[0.82 0.87]);
set(ax1_in,'TickDir','in','LineWidth',1,'FontSize',8);
ax1_in.GridAlpha = 0.15;

% ====== 拖尾局部图（2D） ======
h_tail1 = 0.22 * pos1(4);     % 高度略小
w_tail1 = 0.42 * pos1(3);

x_tail1 = pos1(1) + 0.50 * pos1(3);
y_tail1 = pos1(2) + 0.06 * pos1(4);    

ax1_tail = axes('Position',[x_tail1, y_tail1, w_tail1, h_tail1]);
hold(ax1_tail,'on'); box(ax1_tail,'on'); grid(ax1_tail,'on');

scatter(ax1_tail, bin_centers1, counts1, msz, ...
    'MarkerFaceColor','none','MarkerEdgeColor',[0 0 1]);

plotStyled(ax1_tail, x1,     y1,     'Hinde and Miles',1.0);
plotStyled(ax1_tail, x2,     y2,     'Tanemura',1.0);
plotStyled(ax1_tail, x3,     y3,     'Weaire et al',1.0);
plotStyled(ax1_tail, x4,     y4,     'DiCenzo and Wertheim',1.0);
plotStyled(ax1_tail, x5,     y5,     'Ferenc and Neda',1.0);
plotStyled(ax1_tail, x1_2d,  y1_2d,  'Proposed (TG)',1.0);
plotStyled(ax1_tail, x2_2d,  y2_2d,  'Proposed (GG)',1.0);

% ====== 设置拖尾放大范围（右尾） ======
xlim(ax1_tail,[4.0 4.2]);
ylim(ax1_tail,[1e-4 8e-4]);

set(ax1_tail,'TickDir','in','LineWidth',1,'FontSize',8);
ax1_tail.GridAlpha = 0.15;

% 导出 (a)
print(figA, '-depsc', '-painters', 'Fig-Voronoi_PDF_2D.eps');
print(figA, '-dpdf',  '-painters', 'Fig-Voronoi_PDF_2D.pdf');

%% ===================== 图 (b)：3D 体积（独立文件） =====================
figB = figure('Units','centimeters','Position',[2 2 figW figH]);
set(figB,'PaperUnits','centimeters','PaperPosition',[0 0 figW figH]);

ax2 = axes('Parent',figB); hold(ax2,'on'); box(ax2,'on'); grid(ax2,'on');

[counts2, edges2] = histcounts(valid_volumes, 400, 'Normalization','pdf');
bin_centers2 = (edges2(1:end-1) + edges2(2:end))/2;
scatter(ax2, bin_centers2, counts2, msz, ...
    'MarkerEdgeColor',[0 0 1], ...
    'LineWidth',0.8, ...
    'DisplayName','Empirical');

plotStyled(ax2, x7,     y7,     'Kiang',    lw);
plotStyled(ax2, x_3d,   y_3d,   'Proposed (TG)',    lw);
plotStyled(ax2, x6,     y6,     'Tanemura', lw);
plotStyled(ax2, x2_3d,  y2_3d,  'Proposed (GG)',    lw);
plotStyled(ax2, x8,     y8,     'Ferenc and Neda',   lw);

xlim(ax2,[0 5.5]);
ylim(ax2,[0 1.5]);
xlabel(ax2,'$v$','Interpreter','latex','FontSize',fs_label);
ylabel(ax2,'$f(v)$','Interpreter','latex','FontSize',fs_label);
set(ax2,'TickDir','in','LineWidth',1);
ax2.GridAlpha = 0.15;

lg2 = legend(ax2,'show','Location', [0.22 0.8 0.6 0.08],'FontSize',fs_legend, 'NumColumns',2);
set(lg2,'Box','off');

% ====== 峰值局部图（3D） ======
pos2 = get(ax2,'Position');     
w_in2 = 0.42 * pos2(3);
h_in2 = 0.3 * pos2(4);
x_in2 = pos2(1) + 0.50 * pos2(3);
y_in2 = pos2(2) + 0.40 * pos2(4); 
ax2_in = axes('Position',[x_in2, y_in2, w_in2, h_in2]);
hold(ax2_in,'on'); box(ax2_in,'on'); grid(ax2_in,'on');

scatter(ax2_in, bin_centers2, counts2, msz, ...
    'MarkerFaceColor','none', 'MarkerEdgeColor',[0 0 1]);

plotStyled(ax2_in, x6,     y6,     'Tanemura', 1.0);
plotStyled(ax2_in, x7,     y7,     'Kiang',    1.0);
plotStyled(ax2_in, x8,     y8,     'Ferenc and Neda',   1.0);
plotStyled(ax2_in, x_3d,   y_3d,   'Proposed (TG)',    1.0);
plotStyled(ax2_in, x2_3d,  y2_3d,  'Proposed (GG)',    1.0);

xlim(ax2_in,[0.6 1]);
ylim(ax2_in,[0.9 1.06]);
set(ax2_in,'TickDir','in','LineWidth',1,'FontSize',8);
ax2_in.GridAlpha = 0.15;

% ====== 拖尾局部图（3D） ======
h_tail2 = 0.22 * pos2(4);     % 高度略小
w_tail2 = 0.42 * pos2(3);

x_tail2 = pos2(1) + 0.50 * pos2(3);
y_tail2 = pos2(2) + 0.06 * pos2(4);    % 在峰值 inset 上方

ax2_tail = axes('Position',[x_tail2, y_tail2, w_tail2, h_tail2]);
hold(ax2_tail,'on'); box(ax2_tail,'on'); grid(ax2_tail,'on');

scatter(ax2_tail, bin_centers2, counts2, msz, ...
     'MarkerFaceColor','none','MarkerEdgeColor',[0 0 1]);

plotStyled(ax2_tail, x6,     y6,     'Tanemura',1.0);
plotStyled(ax2_tail, x7,     y7,     'Kiang',1.0);
plotStyled(ax2_tail, x8,     y8,     'Ferenc and Neda',1.0);
plotStyled(ax2_tail, x_3d,   y_3d,   'Proposed (TG)',1.0);
plotStyled(ax2_tail, x2_3d,  y2_3d,  'Proposed (GG)',1.0);

% ====== 拖尾范围 ======
xlim(ax2_tail,[3.0 3.2]);
ylim(ax2_tail,[1e-4 5e-3]);


set(ax2_tail,'TickDir','in','LineWidth',1,'FontSize',8);
ax2_tail.GridAlpha = 0.15;

% 导出 (b)
print(figB, '-depsc', '-painters', 'Fig-Voronoi_PDF_3D.eps');
print(figB, '-dpdf',  '-painters', 'Fig-Voronoi_PDF_3D.pdf');
