for i = 1: 124
    shape = data.shape(:,i);
    shape = reshape(shape,[24223 3]);
    T = ones(length(shape(:,1)),4);
    T(:,1:3) = shape;
    proj_land = T * f_T';
    depth_map = ZBuffer(shape,proj_land,data.face);
    imshow(depth_map, []);
end