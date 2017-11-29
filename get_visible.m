
function vis = get_visible(shape,proj_T,face)

% face = compute_delaunay(shape);
[normal,normalf] = compute_normal(shape,face);

m1 = proj_T(1,1:3);  norm_m1 = norm(m1);
m2 = proj_T(2,1:3);  norm_m2 = norm(m2);
temp = cross(m1/norm_m1,m2/norm_m2);

vis = -normal' * temp';
vis(find(vis<=0))=0;
vis(find(vis>0))=1;
