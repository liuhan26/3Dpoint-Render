
load part_mean_data2.mat;
load proj.mat;
load bu3d_path.mat;

mean_shape = part_shape;
face = part_face;
lm_index = part_lm_index;
mean_shape = double(mean_shape-repmat(mean(mean_shape),size(mean_shape,1),1));
mean_shape(:,3) = mean_shape(:,3)-min(mean_shape(:,3));
mean_lm3 = mean_shape(lm_index([40 37 43 46 32 36 31 34]), :);

image_size = 450;

bu3d_data(length(path)).VV = [];
bu3d_data(length(path)).FF = [];
bu3d_data(length(path)).TF = [];
bu3d_data(length(path)).VT = [];
bu3d_data(length(path)).I = [];
bu3d_data(length(path)).lm3 = [];
bu3d_data(length(path)).proj_shape = [];
for num = 1:length(path)
    num
    file_path = path{num};
    wrl_path_list = dir(strcat(file_path,'*.wrl'));
    wrl_name = wrl_path_list(34).name;  % #34 neural_exp
    w_temp_name = wrl_name(1:12);
    imageName = [w_temp_name '_F3D.bmp'];
    data = read_bu3d_VRML([file_path wrl_name],[file_path imageName]);
    
    fid = fopen([file_path w_temp_name '_RAW.pse']);
    temp = textscan(fid,'%d %f %f %f',8);
    t_lm3(:,1) = temp{1,2};
    t_lm3(:,2) = temp{1,3};
    t_lm3(:,3) = temp{1,4};
    fclose(fid);
    
    shape = data.VV;
    vFace = data.FF;
    tFace = data.TF;
    texCoord =data.VT;
    lm3 = t_lm3;
    img = data.I;
    texCoord(:,1) = round((size(img,2)).*(texCoord(:,1))) + 1;
    texCoord(:,2) = round((size(img,1)).*(texCoord(:,2))) + 1;
    texCoord(:,2) = size(img,1) - texCoord(:,2) + 1;
    
    
    bu3d_data(num).FF = data.FF;
    bu3d_data(num).TF = data.TF;
    bu3d_data(num).VT = data.VT;
    bu3d_data(num).I = data.I;
    bu3d_data(num).lm3 = t_lm3;
    % align shape
    [n_shape] = my_procrustes(mean_lm3,lm3,shape);
    bu3d_data(num).VV = n_shape;
    
    new_Project = f * R * n_shape' + repmat(t3d, 1, size(n_shape, 1));
    new_Project(2,:) = 450 + 1 - new_Project(2,:);
    
    map_img = ones([image_size, image_size, 3], 'uint8')* 255;
    map_coord = floor(new_Project(1:2, :)' + 0.5);
    bu3d_data(num).proj_shape = map_coord;
    mask = zeros(image_size, image_size);
    
    for iface = 1:size(vFace, 1)
        dst_2d = map_coord(vFace(iface,:),:);
        src_2d = texCoord(tFace(iface,:),:);
        
        aff_T = regAffine(src_2d', dst_2d');
        for x_i = min(dst_2d(:,1)):max(dst_2d(:,1))
            for y_i = min(dst_2d(:,2)):max(dst_2d(:,2))
                if triCpoint([x_i y_i], dst_2d)  %isPointInTriangle
                    src_point = aff_T * [x_i y_i 1]';
                    if y_i < size(map_img, 1) && x_i < size(map_img, 2) && y_i>0 && x_i >0 && ~mask(y_i, x_i)
                        map_img(y_i, x_i, :) =  img(ceil(src_point(2)), ceil(src_point(1)), :);
                        mask(y_i, x_i) =  1;
                    end
                end
            end
        end
    end
    
    %     figure, imshow(map_img);
    imwrite(map_img, ['.\frontal_img\BU3D_' num2str(num, '%04d') '.jpg']);
end

save('bu3d_neutral_data.mat','bu3d_data');

