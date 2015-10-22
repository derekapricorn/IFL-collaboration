function [im_out]= imsharp(im_in)
%function imsharp takes in the image in RGB and sharpens the frizzes 
%dynamic range: 0-2^8
%red = [256, 0, 0]
%black = [0,0,0]
%blue = [0,0,256]
im_size = size(im_in);
im_out = zeros(im_size);
for ii = 1:im_size(1)
    for jj = 1:im_size(2)
        im_temp = im2double(im_in);
        im_temp = im_temp(ii,jj,:);
        dist_r = sqrt((im_temp(1)-255)^2 + (im_temp(2))^2 + (im_temp(3))^2);
        dist_b = sqrt((im_temp(1))^2 + (im_temp(2))^2 + (im_temp(3)-255)^2);
        dist_k = sqrt((im_temp(1))^2 + (im_temp(2))^2 + (im_temp(3)^2));
        dist_w = sqrt((im_temp(1)-255)^2 + (im_temp(2)-255)^2 + (im_temp(3)-255)^2);
        
        min_dist = min([dist_r,dist_b,dist_k,dist_w]);
        if dist_r == min_dist
            im_out(ii,jj,:) = [255 0 0];
        elseif dist_b == min_dist
            im_out(ii,jj,:) = [0 0 255];
        elseif dist_k == min_dist
            im_out(ii,jj,:) = [0 0 0];
        elseif dist_w == min_dist
            im_out(ii,jj,:) = [255 255 255];
        end
        
    end
end

end

  