% for i = 1: 124
%     shape = data.shape(:,i);
%     shape = reshape(shape,[24223 3]);
%     T = ones(length(shape(:,1)),4);
%     T(:,1:3) = shape;
%     proj_land = T * f_T';
%     depth_map = ZBuffer(shape,proj_land,data.face);
%     imshow(depth_map, []);
% end
root = '/media/liuhan/LIUHAN/BRL/rgbd_data/';
save_root = '/home/liuhan/Desktop/low_high_depth/';
people = dir(root);
for q = 3:length(people)
    pts_path = dir([root people(q).name filesep 'ir/*.txt']);
    for p = 3:length(pts_path)
        pts_file = [root people(q).name filesep 'ir' filesep pts_path(p).name];
        s = regexp(pts_path(p).name,'ir','split');
        img_name = [s{1} 'depth' s{2}(1:end-3) 'png'];
        ID = 18;
        fid = fopen(pts_file,'r');
        pts = textscan(fid,'%d;');
        M = zeros(5,2);
        M(:,1) = pts{1}(1:5);
        M(:,2) = pts{1}(6:10);
        T = shape{ID}(lm_index1,:);
        S = zeros(5,3);
        S(1,:) = (T(37,:) + T(40,:))/2;
        S(2,:) = (T(43,:) + T(46,:))/2;
        S(3,:) = T(31,:);
        S(4,:) = T(49,:);
        S(5,:) = T(55,:);
        shape_T = ones(24223,4);
        shape_T(:,1:3) = shape{ID};
        proj_T = weak_projection(M',S');
        vis = computer_visible(shape{ID}, mean_face, proj_T);
        proj_land = shape_T * proj_T';
        depth_map = ZBuffer(shape{ID},proj_land,mean_face,vis);
        min_z = min(min(depth_map));
        for i = 1:480
            for j = 1:640
                if depth_map(i,j)==0
                    continue;
                else
                    depth_map(i,j) = depth_map(i,j) - min_z;
                end
            end
        end        
        %imshow(depth_map,[]);
        max_num = max(max(depth_map));
        depth_map = depth_map/max_num;
        if ~exist([save_root people(q).name],'dir')
            mkdir([save_root people(q).name]);
        end 
        if ~exist([save_root people(q).name filesep 'low'],'dir')
            mkdir([save_root people(q).name filesep 'low']);
        end
        if ~exist([save_root people(q).name filesep 'high'],'dir')
            mkdir([save_root people(q).name filesep 'high']);
        end
        original_depth = imread([root people(q).name filesep 'depth' filesep img_name]);
        center_point(1) = (pts{1}(11) + pts{1}(13))/2;
        center_point(2) = (pts{1}(12) + pts{1}(14))/2;
        rec_length = pts{1}(14) - pts{1}(12);
        original_crop = imcrop(original_depth,[center_point(1)-rec_length/2 center_point(2)-rec_length/2 rec_length-1 rec_length-1]);
        depth_map_crop = imcrop(depth_map,[center_point(1)-rec_length/2 center_point(2)-rec_length/2 rec_length-1 rec_length-1]);
        imwrite(original_crop,[save_root people(q).name filesep 'low' filesep img_name]);
        imwrite(1-depth_map_crop, [save_root people(q).name filesep 'high' filesep img_name]);
        %copyfile(pts_file,[save_root people(q).name filesep 'low' filesep pts_path(p).name]);
    end
end