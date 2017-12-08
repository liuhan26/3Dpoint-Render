% for i = 1: 124
%     shape = data.shape(:,i);
%     shape = reshape(shape,[24223 3]);
%     T = ones(length(shape(:,1)),4);
%     T(:,1:3) = shape;
%     proj_land = T * f_T';
%     depth_map = ZBuffer(shape,proj_land,data.face);
%     imshow(depth_map, []);
% end
fid = fopen('/media/liuhan/LIUHAN/BRL/lishuiwang/ir/0002_01_ir_0480.txt','r');
pts = textscan(fid,'%d;');
M = zeros(5,2);
M(:,1) = pts{1}(1:5);
M(:,2) = pts{1}(6:10);
T = shape{18}(lm_index1,:);
S = zeros(5,3);
S(1,:) = (T(37,:) + T(40,:))/2;
S(2,:) = (T(43,:) + T(46,:))/2;
S(3,:) = T(31,:);
S(4,:) = T(49,:);
S(5,:) = T(55,:);
shape_T = ones(24223,4);
shape_T(:,1:3) = shape{18};
proj_T = weak_projection(M',S');
proj_land = shape_T * proj_T';
depth_map = ZBuffer(shape{18},proj_land,mean_face);
for i = 1:480
    for j = 1:640
        if depth_map(i,j)==0
            continue;
        else
            depth_map(i,j) = depth_map(i,j) - min_z;
        end
    end
end
vis = computer_visible(shape{18}, mean_face, proj_T);
imshow(depth_map,[]);