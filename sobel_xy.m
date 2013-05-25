%SOBEL_XY
function [Fx,Fy]=sobel_xy(Image)
    [ImageRow, ImageCol] = size(Image);
    Fx = zeros(ImageRow,ImageCol);
    Fy = zeros(ImageRow,ImageCol);
    %surround Image with a boundary of 1 pixal width(to avoid overflow in the following calculation)  
    %the value of boundary is equal to the nearest edgepixel value
    Image = double(Image);
    tmpImg = [Image(:,1), Image, Image(:,ImageCol)];
    tmpImg = [tmpImg(1,:); tmpImg; tmpImg(ImageRow,:)];    
    
    for i = 2:1:(ImageRow+1)      %(rowNum+1) = the row number of tmpImg - 2
        for j = 2:1:(ImageCol+1)  %(colNum+1) = the col number of tmpImg - 2
        Fx(i-1,j-1) = tmpImg(i-1,j-1)-tmpImg(i-1,j+1)+2*tmpImg(i,j-1)-2*tmpImg(i,j+1)+tmpImg(i+1,j-1)-tmpImg(i+1,j+1);
        Fy(i-1,j-1) = tmpImg(i-1,j-1)+2*tmpImg(i-1,j)+tmpImg(i-1,j+1)-tmpImg(i+1,j-1)-2*tmpImg(i+1,j)-tmpImg(i+1,j+1);
        end
    end
end