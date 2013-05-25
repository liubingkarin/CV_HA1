%HARRIS_DETEKTOR
%function Merkmale=harris_detektor(varargin)
function Merkmale=harris_detektor(Bild, W, k, tau,tile_size,  N, min_dist, do_plot)
%todo to set the default value
%p = inputParser;
%addParamValue(p,'do_plot',true);
%parse(p,'do_plot',100);
%p.Results;

%todo prüfen, ob das Bild im richtigen Format vorliegt
[Fx, Fy] = sobel_xy(Bild);
[WRow, WCol]= size(W);
[BildRow, BildCol] = size(Bild);


P_IxIx = Fx.*Fx;
P_IxIy = Fx.*Fy;
P_IyIy = Fy.*Fy;
sigmaIxIx = conv2(P_IxIx,W,'same');
sigmaIxIy = conv2(P_IxIy,W,'same');
sigmaIyIy = conv2(P_IyIy,W,'same');

C = sigmaIxIx.*sigmaIyIy-sigmaIxIy.*sigmaIxIy-k*(sigmaIxIx+sigmaIyIy).*(sigmaIxIx+sigmaIyIy);

tmp = size(tile_size);
if(tmp(1,2) == 1)
    tile_size = tile_size*ones(1,2);
end
tileBreite = tile_size(1,1);
tileHoehe = tile_size(1,2);
C = [C zeros(BildRow,ceil(BildCol/tileBreite)*tileBreite-BildCol)];
C = [C; zeros(ceil(BildRow/tileHoehe)*tileHoehe-BildRow,ceil(BildCol/tileBreite)*tileBreite)];
C(C<tau(2)) = 0;

remainVal = zeros(size(C));
for m = 1:tileHoehe:(BildRow-tileHoehe+1)
    for n = 1:tileBreite:(BildCol-tileBreite+1)
        tile = C(m:m+tileHoehe-1,n:n+tileBreite-1);
        [VAL,IDX] = sort(tile(:),'descend');
        [I J] = ind2sub([tileHoehe,tileBreite],IDX(1:N));
        IDX = sub2ind(size(C),I+m-1,J+n-1);
        remainVal(IDX) = C(IDX);
    end
end
[r,c,v] = find(remainVal>0);
[sortedV,sortedIdx] = sort(v(:),'descend');
sortedR = r(sortedIdx);
sortedC = c(sortedIdx);

remainPoint = zeros(length(sortedV),2);
remainPoint(1,1) = sortedR(1);
remainPoint(1,2) = sortedC(1);
remainPointNum = 1;
for i = 2:1:length(sortedV)
    breakFlag = false;
    for j = remainPointNum:-1:1
        Abstand = norm([sortedR(i)-remainPoint(j,1), sortedC(i)-remainPoint(j,2)]);
        if Abstand < min_dist
            breakFlag = true;
            break
        end
    end
    if (~breakFlag)
        remainPointNum = remainPointNum+1;
        remainPoint(remainPointNum,1) = sortedR(i);
        remainPoint(remainPointNum,2) = sortedC(i);
    end
end

Merkmale = remainPoint;
[tmpMerkmale(:,3), tmpMerkmale(:,4)] = find(C<tau(1));

if(do_plot)
    imshow(Bild);
    hold on;
    title('Bild with markers of corners and edges');
    plot(Merkmale(:,2),Merkmale(:,1),'r.');
    %plot(tmpMerkmale(:,4),tmpMerkmale(:,3),'g.');
    hold off;
end
end
