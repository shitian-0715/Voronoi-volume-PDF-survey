function valid_areas = areas(A_xmin,A_xmax,A_ymin,A_ymax, guard_ratio)

% ---------------- 原窗口 ----------------
W_xmin = A_xmin;
W_xmax = A_xmax;
W_ymin = A_ymin;
W_ymax = A_ymax;

Lx = W_xmax - W_xmin;
Ly = W_ymax - W_ymin;

% ---------------- 扩展窗口 ----------------
margin_x = guard_ratio * Lx;
margin_y = guard_ratio * Ly;

Wext_xmin = W_xmin - margin_x;
Wext_xmax = W_xmax + margin_x;
Wext_ymin = W_ymin - margin_y;
Wext_ymax = W_ymax + margin_y;

% ---------------- PPP 生成 ----------------
lambda = 1;

Wext_area = (Wext_xmax - Wext_xmin) * (Wext_ymax - Wext_ymin);

% PPP point count: N ~ Poisson(lambda * |Wext|)
N = poissrnd(lambda * Wext_area);

x = Wext_xmin + (Wext_xmax - Wext_xmin) * rand(N,1);
y = Wext_ymin + (Wext_ymax - Wext_ymin) * rand(N,1);

% ---------------- Delaunay ----------------
dt = delaunayTriangulation(x,y);
[vertices, cells] = voronoiDiagram(dt);

% 预分配（最大可能长度）
valid_areas = zeros(length(cells),1);
count = 0;

for i = 1:length(cells)

    xi = x(i);
    yi = y(i);

    % nucleus 必须在原窗口
    if xi < W_xmin || xi > W_xmax || yi < W_ymin || yi > W_ymax
        continue;
    end

    cellVertices = vertices(cells{i}, :);

    % 跳过无穷单元
    if any(isinf(cellVertices(:)))
        continue;
    end

    % 顶点不能触及扩展窗口边界
    if any(cellVertices(:,1) <= Wext_xmin) || ...
       any(cellVertices(:,1) >= Wext_xmax) || ...
       any(cellVertices(:,2) <= Wext_ymin) || ...
       any(cellVertices(:,2) >= Wext_ymax)
        continue;
    end

    count = count + 1;
    valid_areas(count) = polyarea(cellVertices(:,1), cellVertices(:,2));

end

% 截断无效部分
valid_areas = valid_areas(1:count);

end
