%RGB_TO_GRAY
function Gray_image = rgb_to_gray(Image)
    %check if Image is already graypic
    tmp = size(size(Image));
    if  tmp(1,2) == 2
        Gray_image = double(Image);
    else%tmp(1,2) == 3
    Gray_image = 0.299*Image(:,:,1) + 0.587*Image(:,:,2) + 0.114*Image(:,:,3);
    end
end