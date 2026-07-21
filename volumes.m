function valid_volumes = volumes( ...
    A_xmin, A_xmax, ...
    A_ymin, A_ymax, ...
    A_zmin, A_zmax, ...
    guard_ratio)

% ---------------- 原窗口 ----------------
W_xmin = A_xmin;  W_xmax = A_xmax;
W_ymin = A_ymin;  W_ymax = A_ymax;
W_zmin = A_zmin;  W_zmax = A_zmax;

Lx = W_xmax - W_xmin;
Ly = W_ymax - W_ymin;
Lz = W_zmax - W_zmin;

% ---------------- 扩展窗口 ----------------
margin_x = guard_ratio * Lx;
margin_y = guard_ratio * Ly;
margin_z = guard_ratio * Lz;

Wext_xmin = W_xmin - margin_x;
Wext_xmax = W_xmax + margin_x;
Wext_ymin = W_ymin - margin_y;
Wext_ymax = W_ymax + margin_y;
Wext_zmin = W_zmin - margin_z;
Wext_zmax = W_zmax + margin_z;

% ---------------- PPP ----------------
lambda = 1;

Wext_volume = (Wext_xmax - Wext_xmin) * ...
              (Wext_ymax - Wext_ymin) * ...
              (Wext_zmax - Wext_zmin);

% 固定点数（更稳定）
N = round(lambda * Wext_volume);

points = [ ...
    Wext_xmin + (Wext_xmax - Wext_xmin) * rand(N,1), ...
    Wext_ymin + (Wext_ymax - Wext_ymin) * rand(N,1), ...
    Wext_zmin + (Wext_zmax - Wext_zmin) * rand(N,1)];

% ---------------- Voronoi ----------------
[V, C] = voronoin(points);

% 预分配
valid_volumes = zeros(length(C),1);
count = 0;

for i = 1:length(C)

    xi = points(i,1);
    yi = points(i,2);
    zi = points(i,3);

    % nucleus 在原窗口内
    if xi < W_xmin || xi > W_xmax || ...
       yi < W_ymin || yi > W_ymax || ...
       zi < W_zmin || zi > W_zmax
        continue;
    end

    cell_indices = C{i};

    % 排除无穷单元
    if isempty(cell_indices) || any(cell_indices == 1)
        continue;
    end

    vertices = V(cell_indices, :);

    % 顶点不能触碰扩展边界
    if any(vertices(:,1) <= Wext_xmin) || ...
       any(vertices(:,1) >= Wext_xmax) || ...
       any(vertices(:,2) <= Wext_ymin) || ...
       any(vertices(:,2) >= Wext_ymax) || ...
       any(vertices(:,3) <= Wext_zmin) || ...
       any(vertices(:,3) >= Wext_zmax)
        continue;
    end

    % 至少 4 个点
    if size(vertices,1) >= 4
        [~, vol] = convhull(vertices);
        count = count + 1;
        valid_volumes(count) = vol;
    end

end

valid_volumes = valid_volumes(1:count);

end